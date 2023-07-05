package com.reactnativevideoconference;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import org.jitsi.meet.sdk.JitsiMeetActivity;
import org.jitsi.meet.sdk.JitsiMeetConferenceOptions;
import org.jitsi.meet.sdk.JitsiMeetView;

public class JitsiMeetActivityExtended extends JitsiMeetActivity {

  private static JitsiMeetActivityCallback callback;
  private static Boolean isActivityOpen = false;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
   if (callback != null) {
     callback.onCreated(this);
     // clean the callback to prevent multiples requests
     callback = null;
   }
  }

  @Override
  protected void onUserLeaveHint() { handlePictureInPicture();}

  private PictureInPictureCloseListener pictureInPictureCloseListener;

  public void setPiPCloseListener(PictureInPictureCloseListener listener) {
    this.pictureInPictureCloseListener = listener;
  }

  public static void setCallback(JitsiMeetActivityCallback callback) {
    JitsiMeetActivityExtended.callback = callback;
  }


  @Override
  public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode) {
    super.onPictureInPictureModeChanged(isInPictureInPictureMode);

    if (isInPictureInPictureMode) {
      Log.d("refer_log", "enter-pip");
      if (pictureInPictureCloseListener != null) {
        pictureInPictureCloseListener.onEnterPictureInPicture();
      }
    } else {
      if (!isActivityOpen && pictureInPictureCloseListener != null) {
        pictureInPictureCloseListener.onPictureInPictureClosed();
      }
    }
  }

  @Override
  public void onStop() {
    super.onStop();
    isActivityOpen = false;
  }

  public static void launchExtended(Context context, JitsiMeetConferenceOptions options) {
    Intent intent = new Intent(context, JitsiMeetActivityExtended.class);

    intent.setAction("org.jitsi.meet.CONFERENCE");
    intent.putExtra("JitsiMeetConferenceOptions", options);

    if (!(context instanceof Activity)) {
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    }

    context.startActivity(intent);
    isActivityOpen = true;

  }


  private void handlePictureInPicture() {
    JitsiMeetConferenceOptions conferenceOptions = getIntent().getParcelableExtra("JitsiMeetConferenceOptions");

    if (conferenceOptions != null) {
      Bundle flags = conferenceOptions.getFeatureFlags();

      if (flags != null) {
        if (flags.getBoolean("pip.enabled")) {
          JitsiMeetView view = this.getJitsiView();
          if (view != null) {
            view.enterPictureInPicture();
          }
        }
      }
    }
  }
}
