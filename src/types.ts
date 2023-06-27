export interface VideoUserInfo {
  name?: string;
  email?: string;
  avatar?: string;
}

export type EventListener = (event: VideoConferenceEventType) => void;

export interface VideoConferenceCapabilities {
  addPeople: boolean;
  calendar: boolean;
  audioMute: boolean;
  videoMute: boolean;
  callIntegration: boolean;
  carMode: boolean;
  closeCaptions: boolean;
  conferenceTimer: boolean;
  chat: boolean;
  filmStrip: boolean;
  invite: boolean;
  speakerStats: boolean;
  kickOut: boolean;
  meetingName: boolean;
  meetingPassword: boolean;
  notifications: boolean;
  overflowMenu: boolean;
  preJoinPage: boolean;
  raiseHand: boolean;
  serverUrlChange: boolean;
  settings: boolean;
  tileView: boolean;
  videoShare: boolean;
  recordingIos: boolean;
  recordingAndroid: boolean;
  liveStreaming: boolean;
  pip: boolean;
  toolboxAlwaysVisible: boolean;
  welcomePage: boolean;
  fullScreen: boolean;
  audioFocus: boolean;
  audioOnly: boolean;
  help: boolean;
  screenSharingIos: boolean;
  screenSharingAndroid: boolean;
  lobbyMode: boolean;
  pipWhileScreenSharing: boolean;
  preJoinPageHideName: boolean;
  reactions: boolean;
  replaceParticipant: boolean;
  securityOptions: boolean;
  toolbox: boolean;
}

export interface VideoConferenceOptions {
  room: string;
  serverUrl?: string;
  userInfo?: VideoUserInfo;
  serverCredentials?: string;
  startingSettings?: {
    subject?: string;
    audioOnly?: boolean;
    audioMuted?: boolean;
    videoMuted?: boolean;
  };
  capabilities: VideoConferenceCapabilities;
}

interface Event<T extends string, D extends object> {
  type: T;
  data: D;
}

export type VideoConferenceEventType =
  | Event<'conference-start', { url: string }>
  | Event<'conference-joined', { url: string }>
  | Event<'conference-terminated', { url: string; error?: string }>
  | Event<'conference-will-join', { url: string }>
  | Event<'enter-pip', {}>
  | Event<
      'participant-joined',
      { participantId: string; email: string; name: string; role: string }
    >
  | Event<'participant-left', { participantId: string }>
  | Event<
      'endpoint-text-message-received',
      { senderId: string; message: string }
    >
  | Event<'screen-share-toggled', { participantId: string; sharing: boolean }>
  | Event<
      'chat-message-received',
      {
        senderId: string;
        message: string;
        isPrivate: boolean;
        timestamp?: string;
      }
    >
  | Event<'chat-toggled', { isOpen: boolean }>
  | Event<'audio-muted-change', { muted: boolean }>
  | Event<'video-muted-change', { muted: boolean }>
  | Event<'ready-to-close', {}>;

export interface VideoConferenceType {
  start: (options: VideoConferenceOptions) => Promise<void>;
  end: () => Promise<void>;
}

export abstract class VideoConference {
  abstract start(options: VideoConferenceOptions): Promise<void>;

  /**
   * Ends the ongoing video conference
   * @throws {TerminateConferenceError}
   */
  abstract end(): Promise<void>;
}
