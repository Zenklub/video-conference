import {
  DeviceEventEmitter,
  NativeEventEmitter,
  NativeModules,
  Platform,
} from 'react-native';
import type {
  JitsiMeetType,
  JitsiMeetEventType,
  EventListener,
  VideoConferenceCapabilities,
} from './types';

const { RNVideoConference } = NativeModules;

const eventEmitter = Platform.select({
  ios: new NativeEventEmitter(RNVideoConference),
  android: DeviceEventEmitter,
});

export default RNVideoConference as JitsiMeetType;

class JitsiMeetEventListener {
  private listeners: EventListener[] = [];

  constructor() {
    eventEmitter?.addListener('onJitsiMeetConference', this.onEventHandler);
  }

  private onEventHandler = (event: JitsiMeetEventType) => {
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

export class CapabilitiesBuilder {
  private capabilities: VideoConferenceCapabilities = {
    addPeople: true,
    calendar: true,
    audioMute: true,
    videoMute: true,
    callIntegration: true,
    carMode: true,
    closeCaptions: true,
    conferenceTimer: true,
    chat: true,
    filmStrip: true,
    invite: true,
    speakerStats: true,
    kickOut: true,
    meetingName: true,
    meetingPassword: true,
    notifications: true,
    overflowMenu: true,
    preJoinPage: true,
    raiseHand: true,
    serverUrlChange: true,
    settings: true,
    tileView: true,
    videoShare: true,

    recordingIos: false,
    recordingAndroid: false,
    liveStreaming: false,
    pip: false,
    toolboxAlwaysVisible: false,
    welcomePage: false,
    fullScreen: false,
    audioFocus: false,
    audioOnly: false,
    help: false,
    screenSharingIos: false,
    screenSharingAndroid: false,
    lobbyMode: false,
    pipWhileScreenSharing: false,
    preJoinPageHideName: false,
    reactions: false,
    replaceParticipant: false,
    securityOptions: false,
    toolbox: false,
  };

  addPeople(value: boolean = true) {
    this.capabilities.addPeople = value;
    return this;
  }

  calendar(value: boolean = true) {
    this.capabilities.calendar = value;
    return this;
  }

  audioMute(value: boolean = true) {
    this.capabilities.audioMute = value;
    return this;
  }

  videoMute(value: boolean = true) {
    this.capabilities.videoMute = value;
    return this;
  }

  callIntegration(value: boolean = true) {
    this.capabilities.callIntegration = value;
    return this;
  }

  carMode(value: boolean = true) {
    this.capabilities.carMode = value;
    return this;
  }

  closeCaptions(value: boolean = true) {
    this.capabilities.closeCaptions = value;
    return this;
  }

  conferenceTimer(value: boolean = true) {
    this.capabilities.conferenceTimer = value;
    return this;
  }

  chat(value: boolean = true) {
    this.capabilities.chat = value;
    return this;
  }

  filmStrip(value: boolean = true) {
    this.capabilities.filmStrip = value;
    return this;
  }

  invite(value: boolean = true) {
    this.capabilities.invite = value;
    return this;
  }

  speakerStats(value: boolean = true) {
    this.capabilities.speakerStats = value;
    return this;
  }

  kickOut(value: boolean = true) {
    this.capabilities.kickOut = value;
    return this;
  }

  meetingName(value: boolean = true) {
    this.capabilities.meetingName = value;
    return this;
  }

  meetingPassword(value: boolean = true) {
    this.capabilities.meetingPassword = value;
    return this;
  }

  notifications(value: boolean = true) {
    this.capabilities.notifications = value;
    return this;
  }

  overflowMenu(value: boolean = true) {
    this.capabilities.overflowMenu = value;
    return this;
  }

  preJoinPage(value: boolean = true) {
    this.capabilities.preJoinPage = value;
    return this;
  }

  raiseHand(value: boolean = true) {
    this.capabilities.raiseHand = value;
    return this;
  }

  serverUrlChange(value: boolean = true) {
    this.capabilities.serverUrlChange = value;
    return this;
  }

  settings(value: boolean = true) {
    this.capabilities.settings = value;
    return this;
  }

  tileView(value: boolean = true) {
    this.capabilities.tileView = value;
    return this;
  }

  videoShare(value: boolean = true) {
    this.capabilities.videoShare = value;
    return this;
  }

  recordingIos(value: boolean = true) {
    this.capabilities.recordingIos = value;
    return this;
  }

  recordingAndroid(value: boolean = true) {
    this.capabilities.recordingAndroid = value;
    return this;
  }

  liveStreaming(value: boolean = true) {
    this.capabilities.liveStreaming = value;
    return this;
  }

  pip(value: boolean = true) {
    this.capabilities.pip = value;
    return this;
  }

  toolboxAlwaysVisible(value: boolean = true) {
    this.capabilities.toolboxAlwaysVisible = value;
    return this;
  }

  welcomePage(value: boolean = true) {
    this.capabilities.welcomePage = value;
    return this;
  }

  fullScreen(value: boolean = true) {
    this.capabilities.fullScreen = value;
    return this;
  }

  audioFocus(value: boolean = true) {
    this.capabilities.audioFocus = value;
    return this;
  }

  audioOnly(value: boolean = true) {
    this.capabilities.audioOnly = value;
    return this;
  }

  help(value: boolean = true) {
    this.capabilities.help = value;
    return this;
  }

  screenSharingIos(value: boolean = true) {
    this.capabilities.screenSharingIos = value;
    return this;
  }

  screenSharingAndroid(value: boolean = true) {
    this.capabilities.screenSharingAndroid = value;
    return this;
  }

  // Generate all setters
  lobbyMode(value: boolean = true) {
    this.capabilities.lobbyMode = value;
    return this;
  }

  pipWhileScreenSharing(value: boolean = true) {
    this.capabilities.pipWhileScreenSharing = value;
    return this;
  }

  preJoinPageHideName(value: boolean = true) {
    this.capabilities.preJoinPageHideName = value;
    return this;
  }

  reactions(value: boolean = true) {
    this.capabilities.reactions = value;
    return this;
  }

  replaceParticipant(value: boolean = true) {
    this.capabilities.replaceParticipant = value;
    return this;
  }

  securityOptions(value: boolean = true) {
    this.capabilities.securityOptions = value;
    return this;
  }

  toolbox(value: boolean = true) {
    this.capabilities.toolbox = value;
    return this;
  }

  build() {
    return this.capabilities;
  }
}

export const JitsiMeetEvent = new JitsiMeetEventListener();
