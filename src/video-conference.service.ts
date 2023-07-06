import {
  DeviceEventEmitter,
  NativeEventEmitter,
  NativeModules,
  Platform,
} from 'react-native';
import {
  RNVideoConferenceProps,
  VideoConferenceOptions,
  VideoConferenceProps,
  VideoConferenceEventListener,
  VideoConferenceEvent,
} from './types';

const { RNVideoConference } = NativeModules;

const eventEmitter = Platform.select({
  ios: new NativeEventEmitter(RNVideoConference),
  android: DeviceEventEmitter,
});

export const NativeVideoConference =
  RNVideoConference as RNVideoConferenceProps;

export class VideoConferenceImplementation extends VideoConferenceProps {
  private static _lazyInstance?: VideoConferenceProps;
  private conferenceOptions?: VideoConferenceOptions;
  private listeners: VideoConferenceEventListener[] = [];

  public get roomId(): string {
    return this.conferenceOptions?.room ?? '';
  }

  constructor() {
    super();
    eventEmitter?.addListener('onVideoConferenceListener', this.onEventHandler);
  }

  private onEventHandler = (event: VideoConferenceEvent) => {
    console.log('onEventHandler', this.listeners.length);
    this.listeners.forEach((listener) => {
      listener(event, this);
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

  static instance() {
    if (!VideoConferenceImplementation._lazyInstance) {
      VideoConferenceImplementation._lazyInstance =
        new VideoConferenceImplementation();
    }
    return VideoConferenceImplementation._lazyInstance!;
  }

  sendEvent(event: VideoConferenceEvent) {
    this.onEventHandler(event);
  }

  async start(options: VideoConferenceOptions) {
    this.conferenceOptions = options;
    return NativeVideoConference.start(options);
  }

  end() {
    return NativeVideoConference.end();
  }
}
