import {
  DeviceEventEmitter,
  NativeEventEmitter,
  NativeModules,
  Platform,
} from 'react-native';
import type {
  VideoConferenceEvent,
  VideoConferenceEventListener,
} from '../types';

const { RNVideoConference } = NativeModules;

const eventEmitter = Platform.select({
  ios: new NativeEventEmitter(RNVideoConference),
  android: DeviceEventEmitter,
});

class EventListenerService {
  private listeners: VideoConferenceEventListener[] = [];

  constructor() {
    eventEmitter?.addListener('onJitsiMeetConference', this.onEventHandler);
  }

  private onEventHandler = (event: VideoConferenceEvent) => {
    this.listeners.forEach((listener) => {
      listener(event);
    });
  };

  addEventListener(listener: VideoConferenceEventListener) {
    // Prevent duplication
    this.removeEventListener(listener);

    this.listeners.push(listener);

    return () => {
      this.removeEventListener(listener);
    };
  }

  removeEventListener(listener: VideoConferenceEventListener) {
    this.listeners = this.listeners.filter((it) => it !== listener);
  }
}

export const VideoConferenceListener = new EventListenerService();
