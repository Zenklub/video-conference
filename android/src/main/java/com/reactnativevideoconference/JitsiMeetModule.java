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

  public void onDestroy() {
    LocalBroadcastManager.getInstance(getReactApplicationContext()).unregisterReceiver(broadcastReceiver);
  }


  @Override
  public void onPictureInPictureClosed() {
    Log.d("listen", "onPictureInPictureClosed");
    WritableMap payload = Arguments.createMap();
    String jsEventName = this.getEventNameForJs(BroadcastEvent.Type.CONFERENCE_TERMINATED);
    WritableMap params = Arguments.createMap();
    params.putMap("data", payload);
    params.putString("type", jsEventName);

    this.reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit("onJitsiMeetConference", params);
  }


  @Override
  public void onEnterPictureInPicture() {
    WritableMap payload = Arguments.createMap();
    String jsEventName = "enter-pip";
    WritableMap params = Arguments.createMap();
    params.putMap("data", payload);
    params.putString("type", jsEventName);

    this.reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit("onJitsiMeetConference", params);
  }

  @ReactMethod
  public void launchJitsiMeetView(ReadableMap options, Promise onConferenceTerminated) {
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
    if (options.hasKey("featureFlags")) {
      ReadableMap featureFlags = options.getMap("featureFlags");
      ReadableMapKeySetIterator iterator = featureFlags.keySetIterator();
      while (iterator.hasNextKey()) {
        String flag = iterator.nextKey();
        Boolean value = featureFlags.getBoolean(flag);
        builder.setFeatureFlag(flag, value);
      }
    }

    JitsiMeetActivityExtended.launchExtended(getReactApplicationContext(), builder.build());
    registerForBroadcastMessages();




    JitsiMeetActivityExtended.setCallback(new JitsiMeetActivityCallback() {
      @Override
      public void onCreated(JitsiMeetActivityExtended activity) {
        registerPictureInPictureCloseListener(activity);
      }
    });
  }

  @ReactMethod
  public void start(ReadableMap options, Promise onConferenceTerminated) {
    launchJitsiMeetView(options, onConferenceTerminated);
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
          "url", "error", "participantId", "email", "name", "role", "senderId", "message", "timestamp"
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
        .emit("onJitsiMeetConference", params);
    }
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
}
