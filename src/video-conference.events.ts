import {
  DeviceEventEmitter,
  NativeEventEmitter,
  NativeModules,
  Platform,
} from 'react-native';
import type { VideoConferenceEventType, EventListener } from './types';

const { RNVideoConference } = NativeModules;

const eventEmitter = Platform.select({
  ios: new NativeEventEmitter(RNVideoConference),
  android: DeviceEventEmitter,
});

class VideoConferenceEventListener {
  private listeners: EventListener[] = [];

  constructor() {
    eventEmitter?.addListener('onJitsiMeetConference', this.onEventHandler);
  }

  private onEventHandler = (event: VideoConferenceEventType) => {
    this.listeners.forEach((listener) => {
      listener(event);
    });
  };

  addEventListener(listener: EventListener) {
    // Prevent duplication
    this.removeEventListener(listener);

    this.listeners.push(listener);

    return () => {
      this.removeEventListener(listener);
    };
  }

  removeEventListener(listener: EventListener) {
    this.listeners = this.listeners.filter((it) => it !== listener);
  }
}

export const VideoConferenceEvent = new VideoConferenceEventListener();
