import UIKit

struct VideoConferenceStartingOptions {
    var subject: String?
    var audioOnly: Bool?
    var audioMuted: Bool?
    var videoMuted: Bool?
    
    class Builder {
        private var options = VideoConferenceStartingOptions()
        
        func build() -> VideoConferenceStartingOptions {
            return options
        }
        
        @discardableResult
        func setSubject(_ subject: String) -> VideoConferenceStartingOptions.Builder {
            options.subject = subject
            return self
        }
        
        @discardableResult
        func setAudioOnly(_ audioOnly: Bool) -> VideoConferenceStartingOptions.Builder {
            options.audioOnly = audioOnly
            return self
        }
        
        @discardableResult
        func setAudioMuted(_ audioMuted: Bool) -> VideoConferenceStartingOptions.Builder {
            options.audioMuted = audioMuted
            return self
        }
        
        @discardableResult
        func setVideoMuted(_ videoMuted: Bool) -> VideoConferenceStartingOptions.Builder {
            options.videoMuted = videoMuted
            return self
        }
    }
    
    static func from(dictionary: NSDictionary) -> VideoConferenceStartingOptions {
        let builder = VideoConferenceStartingOptions.Builder()
        
        if let subject = dictionary["subject"] as? String {
            builder.setSubject(subject)
        }
        if let audioOnly = dictionary["audioOnly"] as? Bool {
            builder.setAudioOnly(audioOnly)
        }
        if let audioMuted = dictionary["audioMuted"] as? Bool {
            builder.setAudioMuted(audioMuted)
        }
        if let videoMuted = dictionary["videoMuted"] as? Bool {
            builder.setVideoMuted(videoMuted)
        }
        
        return builder.build()
    }
}

struct VideoConferenceOptions {
    var serverUrl: String = ""
    var room: String = ""
    var serverCredentials: String? = nil
    
    var startingSettings: VideoConferenceStartingOptions? = nil
    
    class Builder {
        private var options = VideoConferenceOptions()
        
        func build() -> VideoConferenceOptions {
            return options
        }
        
        @discardableResult
        func setServerUrl(_ serverUrl: String) -> VideoConferenceOptions.Builder {
            options.serverUrl = serverUrl
            return self
        }
        
        @discardableResult
        func setRoom(_ room: String) -> VideoConferenceOptions.Builder {
            options.room = room
            return self
        }
    }
    
    static func from(dictionary options: NSDictionary) -> VideoConferenceOptions {
        let builder = VideoConferenceOptions.Builder()
        
        if let roomId = options["room"] as? String {
            builder.setRoom(roomId)
        }
        
        if let server = options["serverUrl"] as? String {
            builder.setServerUrl(server)
        }
        
        if let startingSettings = options["serverUrl"] as? NSDictionary {
            
        }
        
        return builder.build()
    }
}

struct UserData {
    var name: String?
    var avatarUrl: String?
    var email: String?
    
    class Builder {
        private var userData = UserData()
        
        func build() -> UserData {
            return self.userData
        }
        
        @discardableResult
        func setName(_ name: String) -> UserData.Builder {
            userData.name = name
            return self
        }
        
        @discardableResult
        func setAvatarUrl(_ avatarUrl: String) -> UserData.Builder {
            userData.avatarUrl = avatarUrl
            return self
        }
        
        @discardableResult
        func setEmail(_ email: String) -> UserData.Builder {
            userData.email = email
            return self
        }
    }
    
    static func from(dictionary options: NSDictionary) -> UserData {
        let builder = UserData.Builder()
        
        if let name = options["name"] as? String {
            builder.setName(name)
        }
        
        if let avatarUrl = options["avatarUrl"] as? String {
            builder.setAvatarUrl(avatarUrl)
        }
        
        if let email = options["email"] as? String {
            builder.setEmail(email)
        }
        
        return builder.build()
    }
}

struct VideoConferenceCapabilities {
    var addPeople = true
    var calendar = true
    var audioMute = true
    var videoMute = true
    var callIntegration = true
    var carMode = true
    var closeCaptions = true
    var conferenceTimer = true
    var chat = true
    var filmStrip = true
    var invite = true
    var speakerStats = true
    var kickOut = true
    var meetingName = true
    var meetingPassword = true
    var notifications = true
    var overflowMenu = true
    var preJoinPage = true
    var raiseHand = true
    var serverUrlChange = true
    var settings = true
    var tileView = true
    var videoShare = true
    
    var recording = false
    var liveStreaming = false
    var pip = false
    var toolboxAlwaysVisible = false
    var welcomePage = false
    var fullScreen = false
    var audioFocus = false
    var audioOnly = false
    var help = false
    var screenSharing = false
    var lobbyMode = false
    var pipWhileScreenSharing = false
    var preJoinPageHideName = false
    var reactions = false
    var replaceParticipant = false
    var securityOptions = false
    var toolbox = false
    
    class Builder {
        private var capabilities = VideoConferenceCapabilities()
        
        func build() -> VideoConferenceCapabilities{
            return self.capabilities
        }
        
        @discardableResult
        func setAddPeople(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.addPeople = enabled
            return self
        }
        @discardableResult
        func setCalendar(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.calendar = enabled
            return self
        }
        @discardableResult
        func setCloseCaptions(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.closeCaptions = enabled
            return self
        }
        @discardableResult
        func setChat(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.chat = enabled
            return self
        }
        @discardableResult
        func setInvite(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.invite = enabled
            return self
        }
        @discardableResult
        func setRecording(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.recording = enabled
            return self
        }
        @discardableResult
        func setKickOut(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.kickOut = enabled
            return self
        }
        @discardableResult
        func setLiveStreaming(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.liveStreaming = enabled
            return self
        }
        @discardableResult
        func setMeetingName(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.meetingName = enabled
            return self
        }
        @discardableResult
        func setMeetingPassword(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.meetingPassword = enabled
            return self
        }
        @discardableResult
        func setPictureInPicture(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.pip = enabled
            return self
        }
        @discardableResult
        func setRaiseHand(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.raiseHand = enabled
            return self
        }
        @discardableResult
        func setToolboxAlwaysVisible(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.toolboxAlwaysVisible = enabled
            return self
        }
        @discardableResult
        func setTileView(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.tileView = enabled
            return self
        }
        @discardableResult
        func setVideoShare(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.videoShare = enabled
            return self
        }
        @discardableResult
        func setFullScreen(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.fullScreen = enabled
            return self
        }
        
        @discardableResult
        func setConferenceTimer(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.conferenceTimer = enabled
            return self
        }
        
        @discardableResult
        func setPreJoinPage(_ enabled: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.preJoinPage = enabled
            return self
        }
        
        @discardableResult
        func setServerUrlChange(_ serverUrlChange: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.serverUrlChange = serverUrlChange
            return self
        }
        
        @discardableResult
        func setAudioFocus(_ audioFocus: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.audioFocus = audioFocus
            return self
        }
        
        @discardableResult
        func setAudioMute(_ audioMute: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.audioMute = audioMute
            return self
        }
        
        @discardableResult
        func setVideoMute(_ videoMute: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.videoMute = videoMute
            return self
        }
        
        @discardableResult
        func setAudioOnly(_ audioOnly: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.audioOnly = audioOnly
            return self
        }
        
        @discardableResult
        func setCallIntegration(_ callIntegration: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.callIntegration = callIntegration
            return self
        }
        
        @discardableResult
        func setCarMode(_ carMode: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.carMode = carMode
            return self
        }
        
        @discardableResult
        func setHelp(_ help: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.help = help
            return self
        }
        
        @discardableResult
        func setFilmStrip(_ filmStrip: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.filmStrip = filmStrip
            return self
        }
        
        @discardableResult
        func setScreenSharing(_ screenSharing: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.screenSharing = screenSharing
            return self
        }
        
        @discardableResult
        func setSpeakerStats(_ speakerStats: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.speakerStats = speakerStats
            return self
        }
        
        @discardableResult
        func setNotifications(_ notifications: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.notifications = notifications
            return self
        }
        
        @discardableResult
        func setOverflowMenu(_ overflowMenu: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.overflowMenu = overflowMenu
            return self
        }
        
        @discardableResult
        func setLobbyMode(_ lobbyMode: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.lobbyMode = lobbyMode
            return self
        }
        
        @discardableResult
        func setPipWhileScreenSharing(_ pipWhileScreenSharing: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.pipWhileScreenSharing = pipWhileScreenSharing
            return self
        }
        
        @discardableResult
        func setPreJoinPageHideName(_ preJoinPageHideName: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.preJoinPageHideName = preJoinPageHideName
            return self
        }
        
        @discardableResult
        func setReactions(_ reactions: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.reactions = reactions
            return self
        }
        
        @discardableResult
        func setReplaceParticipant(_ replaceParticipant: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.replaceParticipant = replaceParticipant
            return self
        }
        
        @discardableResult
        func setSecurityOptions(_ securityOptions: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.securityOptions = securityOptions
            return self
        }
        
        @discardableResult
        func setSettings(_ settings: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.settings = settings
            return self
        }
        
        @discardableResult
        func setToolbox(_ toolbox: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.toolbox = toolbox
            return self
        }
        
        @discardableResult
        func setWelcomePage(_ welcomePage: Bool = true) -> VideoConferenceCapabilities.Builder {
            capabilities.welcomePage = welcomePage
            return self
        }
    }
    
    
    static func from(dictionary options: NSDictionary?) -> VideoConferenceCapabilities {
        return VideoConferenceCapabilities.Builder()
        
            // Default True
            .setAddPeople(options?["addPeople"] as? Bool ?? true)
            .setCalendar(options?["calendar"] as? Bool ?? true)
            .setAudioMute(options?["audioMute"] as? Bool ?? true)
            .setVideoMute(options?["videoMute"] as? Bool ?? true)
            .setCarMode(options?["carMode"] as? Bool ?? true)
            .setFilmStrip(options?["filmStrip"] as? Bool ?? true)
            .setCloseCaptions(options?["closeCaptions"] as? Bool ?? true)
            .setChat(options?["chat"] as? Bool ?? true)
            .setInvite(options?["invite"] as? Bool ?? true)
            .setCallIntegration(options?["callIntegration"] as? Bool ?? true)
            .setConferenceTimer(options?["conferenceTimer"] as? Bool ?? true)
            .setSpeakerStats(options?["speakerStats"] as? Bool ?? true)
            .setKickOut(options?["kickOut"] as? Bool ?? true)
            .setMeetingName(options?["meetingName"] as? Bool ?? true)
            .setMeetingPassword(options?["meetingPassword"] as? Bool ?? true)
            .setNotifications(options?["notifications"] as? Bool ?? true)
            .setOverflowMenu(options?["overflowMenu"] as? Bool ?? true)
            .setRaiseHand(options?["raiseHand"] as? Bool ?? true)
            .setPreJoinPage(options?["preJoinPage"] as? Bool ?? true)
            .setServerUrlChange(options?["serverUrlChange"] as? Bool ?? true)
            .setSettings(options?["settings"] as? Bool ?? true)
            .setTileView(options?["tileView"] as? Bool ?? true)
            .setVideoShare(options?["videoShare"] as? Bool ?? true)
        
            // Default false
            .setRecording(options?["recording"] as? Bool ?? false)
            .setLiveStreaming(options?["liveStreaming"] as? Bool ?? false)
            .setPictureInPicture(options?["pip"] as? Bool ?? false)
            .setToolboxAlwaysVisible(options?["toolboxAlwaysVisible"] as? Bool ?? false)
            .setWelcomePage(options?["welcomePage"] as? Bool ?? false)
            .setFullScreen(options?["fullScreen"] as? Bool ?? false)
            .setAudioFocus(options?["audioFocus"] as? Bool ?? false)
            .setAudioOnly(options?["audioOnly"] as? Bool ?? false)
            .setHelp(options?["help"] as? Bool ?? false)
            .setScreenSharing(options?["screenSharing"] as? Bool ?? false)
            .setRecording(options?["recording"] as? Bool ?? false)
            .setLobbyMode(options?["lobbyMode"] as? Bool ?? false)
            .setPipWhileScreenSharing(options?["pipWhileScreenSharing"] as? Bool ?? false)
            .setPreJoinPageHideName(options?["preJoinPageHideName"] as? Bool ?? false)
            .setReactions(options?["reactions"] as? Bool ?? false)
            .setReplaceParticipant(options?["replaceParticipant"] as? Bool ?? false)
            .setSecurityOptions(options?["securityOptions"] as? Bool ?? false)
            .setToolbox(options?["toolbox"] as? Bool ?? false)
            .build()
    }
}


protocol RNVideoConferenceViewDelegate {
    
}

protocol RNVideoConferenceViewControllerDelegate: UIViewController {
    func ready(toClose data: [AnyHashable : Any]!) -> Void
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) -> Void
    
    /**
     * Called when a conference was joined.
     *
     * The `data` dictionary contains a `url` key with the conference URL.
     */
    func conferenceJoined(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called when the active conference ends, be it because of user choice or
     * because of a failure.
     *
     * The `data` dictionary contains an `error` key with the error and a `url` key
     * with the conference URL. If the conference finished gracefully no `error`
     * key will be present. The possible values for "error" are described here:
     * https://github.com/jitsi/lib-jitsi-meet/blob/master/JitsiConnectionErrors.ts
     * https://github.com/jitsi/lib-jitsi-meet/blob/master/JitsiConferenceErrors.ts
     */
    func conferenceTerminated(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called before a conference is joined.
     *
     * The `data` dictionary contains a `url` key with the conference URL.
     */
    func conferenceWillJoin(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called when entering Picture-in-Picture is requested by the user. The app
     * should now activate its Picture-in-Picture implementation (and resize the
     * associated `JitsiMeetView`. The latter will automatically detect its new size
     * and adjust its user interface to a variant appropriate for the small size
     * ordinarily associated with Picture-in-Picture.)
     *
     * The `data` dictionary is empty.
     */
    func enterPictureInPicture(data: [AnyHashable : Any]) -> Void

    /**
     * Called when a participant has joined the conference.
     *
     * The `data` dictionary contains a `participantId` key with the id of the participant that has joined.
     */
    func participantJoined(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called when a participant has left the conference.
     *
     * The `data` dictionary contains a `participantId` key with the id of the participant that has left.
     */
    func participantLeft(data: [AnyHashable : Any]) -> Void
    /**
     * Called when audioMuted state changed.
     *
     * The `data` dictionary contains a `muted` key with state of the audioMuted for the localParticipant.
     */
    func audioMutedChanged(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called when an endpoint text message is received.
     *
     * The `data` dictionary contains a `senderId` key with the participantId of the sender and a 'message' key with the content.
     */
    func endpointTextMessageReceived(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called when a participant toggled shared screen.
     *
     * The `data` dictionary contains a `participantId` key with the id of the participant  and a 'sharing' key with boolean value.
     */
    func screenShareToggled(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called when a chat message is received.
     *
     * The `data` dictionary contains `message`, `senderId` and  `isPrivate` keys.
     */
    func chatMessageReceived(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called when the chat dialog is displayed/hidden.
     *
     * The `data` dictionary contains a `isOpen` key.
     */
    func chatToggled(data: [AnyHashable : Any]) -> Void

    /**
     * Called when videoMuted state changed.
     *
     * The `data` dictionary contains a `muted` key with state of the videoMuted for the localParticipant.
     */
    func videoMutedChanged(_ data: [AnyHashable : Any]) -> Void

    /**
     * Called when the SDK is ready to be closed. No meeting is happening at this point.
     */
    func readyToClose(data: [AnyHashable : Any]) -> Void
}
