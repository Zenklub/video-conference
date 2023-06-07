package com.reactnativejitsimeet;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class JitsiMeetActivityManager implements Application.ActivityLifecycleCallbacks {
  private Activity currentActivity;


  public JitsiMeetActivityManager(Application myApplication) {
    myApplication.registerActivityLifecycleCallbacks(this);
  }

  public Activity getCurrentActivity(){
    return currentActivity;
  }
  @Override
  public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle bundle) {
    this. currentActivity = activity;

  }

  @Override
  public void onActivityStarted(@NonNull Activity activity) {
    this. currentActivity = activity;
  }

  @Override
  public void onActivityResumed(@NonNull Activity activity) {
    this. currentActivity = activity;

  }

  @Override
  public void onActivityPaused(@NonNull Activity activity) {

  }

  @Override
  public void onActivityStopped(@NonNull Activity activity) {

  }

  @Override
  public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle bundle) {

  }

  @Override
  public void onActivityDestroyed(@NonNull Activity activity) {

  }
}
