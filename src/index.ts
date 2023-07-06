export { CapabilitiesBuilder } from './utils/capabilities-builder';
export { VideoConferenceListener } from './utils/event-listener';
export { StartConferenceError } from './utils/error.types';

import { NativeVideoConference } from './video-conference.service';
export { VideoConferenceImplementation } from './video-conference.service';

// export types
export {
  VideoConferenceOptions,
  VideoConferenceEvent,
  VideoConferenceProps,
} from './types';

export default NativeVideoConference;
