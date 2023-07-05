package com.reactnativevideoconference;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.facebook.react.bridge.*;
import com.facebook.react.module.annotations.ReactModule;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import org.jitsi.meet.sdk.BroadcastEvent;
import org.jitsi.meet.sdk.BroadcastIntentHelper;
import org.jitsi.meet.sdk.JitsiMeetConferenceOptions;
import org.jitsi.meet.sdk.JitsiMeetUserInfo;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

@ReactModule(name = JitsiMeetModule.NAME)
public class JitsiMeetModule extends ReactContextBaseJavaModule implements  PictureInPictureCloseListener {
  public static final String NAME = "RNVideoConference";

  private ReactApplicationContext reactContext;

  private JitsiMeetActivityExtended jitsiMeetActivityExtended;

  public void registerPictureInPictureCloseListener(JitsiMeetActivityExtended activity) {
    this.jitsiMeetActivityExtended = activity;
    this.jitsiMeetActivityExtended.setPiPCloseListener(this);
  }

  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      onBroadcastReceived(intent);
    }
  };

  public JitsiMeetModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void end() {
    Intent hangupBroadcastIntent = BroadcastIntentHelper.buildHangUpIntent();
    LocalBroadcastManager.getInstance(getReactApplicationContext()).sendBroadcast(hangupBroadcastIntent);
  }

  @Override
  protected void finalize() throws Throwable {
    super.finalize();
    LocalBroadcastManager.getInstance(getReactApplicationContext()).unregisterReceiver(broadcastReceiver);
  }


  @ReactMethod
  public void start(ReadableMap options, Promise onConferenceTerminated) {
    JitsiMeetConferenceOptions.Builder builder = new JitsiMeetConferenceOptions.Builder();

    if (options.hasKey("room")) {
      builder.setRoom(options.getString("room"));
    } else {
      throw new RuntimeException("Room must not be empty");
    }

    try {
      builder.setServerURL(
        new URL(options.hasKey("serverUrl") ? options.getString("serverUrl") : "https://meet.jit.si"));
    } catch (MalformedURLException e) {
      throw new RuntimeException("Server url invalid");
    }

    if (options.hasKey("userInfo")) {
      ReadableMap userInfoMap = options.getMap("userInfo");

      if (userInfoMap != null) {
        JitsiMeetUserInfo userInfo = new JitsiMeetUserInfo();

        if (userInfoMap.hasKey("displayName")) {
          userInfo.setDisplayName(userInfoMap.getString("displayName"));
        }

        if (userInfoMap.hasKey("email")) {
          userInfo.setEmail(userInfoMap.getString("email"));
        }

        if (userInfoMap.hasKey("avatar")) {
          try {
            userInfo.setAvatar(new URL(userInfoMap.getString("avatar")));
          } catch (MalformedURLException e) {
            throw new RuntimeException("Avatar url invalid");
          }
        }

        builder.setUserInfo(userInfo);
      }
    }

    if (options.hasKey("token")) {
      builder.setToken(options.getString("token"));
    }

    // Set built-in config overrides
    if (options.hasKey("subject")) {
      builder.setSubject(options.getString("subject"));
    }

    if (options.hasKey("audioOnly")) {
      builder.setAudioOnly(options.getBoolean("audioOnly"));
    }

    if (options.hasKey("audioMuted")) {
      builder.setAudioMuted(options.getBoolean("audioMuted"));
    }

    if (options.hasKey("videoMuted")) {
      builder.setVideoMuted(options.getBoolean("videoMuted"));
    }

    // Set the feature flags
    if (options.hasKey("capabilities")) {
      ReadableMap capabilities = options.getMap("capabilities");
      ReadableMapKeySetIterator iterator = capabilities.keySetIterator();
      while (iterator.hasNextKey()) {
        String capability = iterator.nextKey();
        Boolean value = capabilities.getBoolean(capability);
        String flagKey = this.getFeatureFlagField(capability);
        builder.setFeatureFlag(flagKey, value);
      }
    }

    JitsiMeetActivityExtended.launchExtended(getReactApplicationContext(), builder.build());
    registerForBroadcastMessages();


    JitsiMeetActivityExtended.setCallback(new JitsiMeetActivityCallback() {
      @Override
      public void onCreated(JitsiMeetActivityExtended activity) {
        registerPictureInPictureCloseListener(activity);
        onConferenceTerminated.resolve(null);
      }
    });
  }

  private void registerForBroadcastMessages() {
    IntentFilter intentFilter = new IntentFilter();

        /* This registers for every possible event sent from JitsiMeetSDK
           If only some of the events are needed, the for loop can be replaced
           with individual statements:
           ex:  intentFilter.addAction(BroadcastEvent.Type.AUDIO_MUTED_CHANGED.getAction());
                intentFilter.addAction(BroadcastEvent.Type.CONFERENCE_TERMINATED.getAction());
                ... other events
         */
    for (BroadcastEvent.Type type : BroadcastEvent.Type.values()) {
      intentFilter.addAction(type.getAction());
    }

    LocalBroadcastManager.getInstance(getReactApplicationContext()).registerReceiver(broadcastReceiver, intentFilter);
  }

  // Example for handling different JitsiMeetSDK events
  private void onBroadcastReceived(Intent intent) {
    if (intent != null) {
      BroadcastEvent event = new BroadcastEvent(intent);

      HashMap<String, Object> data = event.getData();
      BroadcastEvent.Type type = event.getType();

      String jsEventName = this.getEventNameForJs(type);

      if (jsEventName == null) {
        return;
      }

      WritableMap payload = Arguments.createMap();

      if (data != null) {
        List<String> boolKeys = Arrays.asList("muted", "sharing", "isPrivate");
        for (String key : boolKeys) {
          if (data.containsKey(key)) {
            payload.putBoolean(key, data.get(key).equals("true"));
          }
        }

        List<String> stringKeys = Arrays.asList(
          "url", "room", "error", "participantId", "email", "name", "role", "senderId", "message", "timestamp"
        );
        for (String key : stringKeys) {
          if (data.containsKey(key)) {
            payload.putString(key, (String) data.get(key));
          }
        }
      }

      WritableMap params = Arguments.createMap();
      params.putMap("data", payload);
      params.putString("type", jsEventName);

      this.reactContext
        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
        .emit("onVideoConferenceListener", params);
    }
  }

  private void emitEvent(String jsEventName) {
    JitsiMeetConferenceOptions conferenceOptions = this.jitsiMeetActivityExtended.getIntent().getParcelableExtra("JitsiMeetConferenceOptions");
    WritableMap payload = Arguments.createMap();

    WritableMap params = Arguments.createMap();
     if(conferenceOptions !=null && conferenceOptions.getServerURL() != null) {
      String serverUrl = conferenceOptions.getServerURL().toString();
      if(!serverUrl.endsWith("/")) {
        serverUrl += "/";
      }
      String room = conferenceOptions.getRoom().toString();
      payload.putString("url", serverUrl + room);
    }
    params.putMap("data", payload);
    params.putString("type", jsEventName);

    this.reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit("onVideoConferenceListener", params);
  }

  @Override
  public void onPictureInPictureClosed() {
    Log.d("refer_listen", "onPictureInPictureClosed");
    String jsEventName = this.getEventNameForJs(BroadcastEvent.Type.CONFERENCE_TERMINATED);
    this.emitEvent(jsEventName);
    this.end();
  }


  @Override
  public void onEnterPictureInPicture() {
    this.emitEvent("enter-pip");
  }

  private String getEventNameForJs(BroadcastEvent.Type type) {
    switch (type) {
      case CONFERENCE_WILL_JOIN:
        return "conference-will-join";
      case CONFERENCE_JOINED:
        return "conference-joined";
      case CONFERENCE_TERMINATED:
        return "conference-terminated";
      case AUDIO_MUTED_CHANGED:
        return "audio-muted-changed";
      case PARTICIPANT_JOINED:
        return "participant-joined";
      case PARTICIPANT_LEFT:
        return "participant-left";
      case ENDPOINT_TEXT_MESSAGE_RECEIVED:
        return "endpoint-text-message-received";
      case SCREEN_SHARE_TOGGLED:
        return "screen-share-toggled";
      case PARTICIPANTS_INFO_RETRIEVED:
        return "participants-info-retrieved";
      case CHAT_MESSAGE_RECEIVED:
        return "chat-message-received";
      case CHAT_TOGGLED:
        return "chat-toggled";
      case VIDEO_MUTED_CHANGED:
        return "video-muted-changed";
      case READY_TO_CLOSE:
        return "ready-to-close";
    }
    return null;
  }


  private static String getFeatureFlagField(String value) {
      switch (value) {
          case "addPeople":
              return "add-people.enabled";
          case "audioFocus":
              return "audio-focus.disabled";
          case "audioMute":
              return "audio-mute.enabled";
          case "audioOnly":
              return "audio-only.enabled";
          case "calendar":
              return "calendar.enabled";
          case "callIntegration":
              return "call-integration.enabled";
          case "carMode":
              return "car-mode.enabled";
          case "closeCaptions":
              return "close-captions.enabled";
          case "conferenceTimer":
              return "conference-timer.enabled";
          case "chat":
              return "chat.enabled";
          case "filmStrip":
              return "filmstrip.enabled";
          case "fullScreen":
              return "fullscreen.enabled";
          case "help":
              return "help.enabled";
          case "invite":
              return "invite.enabled";
          case "recording":
              return "ios.recording.enabled";
          case "screenSharing":
              return "ios.screensharing.enabled";
          case "speakerStats":
              return "speakerstats.enabled";
          case "kickOut":
              return "kick-out.enabled";
          case "liveStreaming":
              return "live-streaming.enabled";
          case "lobbyMode":
              return "lobby-mode.enabled";
          case "meetingName":
              return "meeting-name.enabled";
          case "meetingPassword":
              return "meeting-password.enabled";
          case "notifications":
              return "notifications.enabled";
          case "overflowMenu":
              return "overflow-menu.enabled";
          case "pip":
              return "pip.enabled";
          case "pipWhileScreenSharing":
              return "pip-while-screen-sharing.enabled";
          case "preJoinPage":
              return "prejoinpage.enabled";
          case "preJoinPageHideName":
              return "prejoinpage.hideDisplayName";
          case "raiseHand":
              return "raise-hand.enabled";
          case "reactions":
              return "reactions.enabled";
          case "replaceParticipant":
              return "replace.participant";
          case "securityOptions":
              return "security-options.enabled";
          case "serverUrlChange":
              return "server-url-change.enabled";
          case "settings":
              return "settings.enabled";
          case "tileView":
              return "tile-view.enabled";
          case "toolboxAlwaysVisible":
              return "toolbox.alwaysVisible";
          case "toolbox":
              return "toolbox.enabled";
          case "videoMute":
              return "video-mute.enabled";
          case "videoShare":
              return "video-share.enabled";
          case "welcomePage":
              return "welcomepage.enabled";
          default:
              return value;
      }
  }
}
