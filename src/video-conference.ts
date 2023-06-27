import { NativeModules } from 'react-native';
import type {
  VideoConferenceType,
  VideoConferenceOptions,
  VideoConference,
} from './types';

const { RNVideoConference } = NativeModules;

const NativeVideoConference = RNVideoConference as VideoConferenceType;

class VideoConferenceClass implements VideoConference {
  start(options: VideoConferenceOptions) {
    return NativeVideoConference.start(options);
  }

  end() {
    return NativeVideoConference.end();
  }
}

export const VideoConferenceService = new VideoConferenceClass();
