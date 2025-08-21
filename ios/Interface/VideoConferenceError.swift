enum RNVideoConferenceError: Error {
    case conferenceAlreadyActive, missingRoom, rootViewNotFound, missingUserInfo
    
    
    
    func getCode() -> String {
        switch self {
        case .conferenceAlreadyActive:
            return "CONFERENCE_ALREADY_ACTIVE"
        case .missingRoom:
            return "MISSING_ROOM"
        case .missingUserInfo:
            return "MISSING_USER_INFO"
        case .rootViewNotFound:
            return "ROOT_VIEW_NOT_FOUND"
        }
    }
    
    func getMessage() -> String {
        switch self {
        case .conferenceAlreadyActive:
            return "You already have an active call."
        case .missingRoom:
            return "You must provide a room"
        case .missingUserInfo:
            return "You must provide the user info"
        case .rootViewNotFound:
            return "RootViewController not found. You most likely forget to instantiate RNVideoConferenceViewController"
        }
    }
}
