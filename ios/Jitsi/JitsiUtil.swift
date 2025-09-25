import Foundation
import JitsiMeetSDK

struct JitsiUtil {
    static func buildConferenceOptions(
        options: VideoConferenceOptions,
        userData: UserData,
        capabilities: VideoConferenceCapabilities
    ) -> JitsiMeetConferenceOptions {
        return JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.room = options.room
          
            builder.serverURL = URL(string: options.serverUrl)
          
            // User Data
            let conferenceUserInfo = JitsiMeetUserInfo()
            if let displayName = userData.name {
                conferenceUserInfo.displayName = displayName
            }
            if let email = userData.email {
                conferenceUserInfo.email = email
            }
            if let avatar = userData.avatar {
                conferenceUserInfo.avatar = URL(string: avatar)
            }
            
            builder.userInfo = conferenceUserInfo
            
          
            if let serverCredentials = options.serverCredentials {
                builder.token = serverCredentials
            }

            // Set built-in config overrides
            if let startingSettings = options.startingSettings {
                if let subject = startingSettings.subject {
                    builder.setSubject(subject)
                }
                
                if let audioOnly = startingSettings.audioOnly {
                    builder.setAudioOnly(audioOnly)
                }
                
                if let audioMuted = startingSettings.audioMuted {
                    builder.setAudioMuted(audioMuted)
                }
                
                if let videoMuted = startingSettings.videoMuted {
                    builder.setVideoMuted(videoMuted)
                }
            }
            
            let featureFlags = self.featureFlags(from: capabilities)

            for (flag, value) in featureFlags {
                builder.setFeatureFlag(flag as! String, withValue: value)
            }
        }
    }
    
    private static func featureFlags(from capabilities: VideoConferenceCapabilities) -> NSDictionary {
        return [
            "add-people.enabled": capabilities.addPeople,
            "audio-focus.disabled": capabilities.audioFocus,
            "audio-mute.enabled": capabilities.audioMute,
            "audio-only.enabled": capabilities.audioOnly,
            "calendar.enabled": capabilities.calendar,
            "call-integration.enabled": capabilities.callIntegration,
            "car-mode.enabled": capabilities.carMode,
            "close-captions.enabled": capabilities.closeCaptions,
            "conference-timer.enabled": capabilities.conferenceTimer,
            "chat.enabled": capabilities.chat,
            "filmstrip.enabled": capabilities.filmStrip,
            "fullscreen.enabled": capabilities.fullScreen,
            "help.enabled": capabilities.help,
            "invite.enabled": capabilities.invite,
            "ios.recording.enabled": capabilities.recording,
            "ios.screensharing.enabled": capabilities.screenSharing,
            "speakerstats.enabled": capabilities.speakerStats,
            "kick-out.enabled": capabilities.kickOut,
            "live-streaming.enabled": capabilities.liveStreaming,
            "lobby-mode.enabled": capabilities.lobbyMode,
            "meeting-name.enabled": capabilities.meetingName,
            "meeting-password.enabled": capabilities.meetingPassword,
            "notifications.enabled": capabilities.notifications,
            "overflow-menu.enabled": capabilities.overflowMenu,
            "pip.enabled": capabilities.pip,
            "pip-while-screen-sharing.enabled": capabilities.pipWhileScreenSharing,
            "prejoinpage.enabled": capabilities.preJoinPage,
            "prejoinpage.hideDisplayName": capabilities.preJoinPageHideName,
            "raise-hand.enabled": capabilities.raiseHand,
            "reactions.enabled": capabilities.reactions,
            "recording.enabled": capabilities.recording,
            "replace.participant": capabilities.replaceParticipant,
            "security-options.enabled": capabilities.securityOptions,
            "server-url-change.enabled": capabilities.serverUrlChange,
            "settings.enabled": capabilities.settings,
            "tile-view.enabled": capabilities.tileView,
            "toolbox.alwaysVisible": capabilities.toolboxAlwaysVisible,
            "toolbox.enabled": capabilities.toolbox,
            "video-mute.enabled": capabilities.videoMute,
            "video-share.enabled": capabilities.videoShare,
            "welcomepage.enabled": capabilities.welcomePage,
        ]
    }
}


