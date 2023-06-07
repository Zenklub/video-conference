
import UIKit

protocol VideoConferenceView: UIView {
    func start(with options: VideoConferenceOptions, userData: UserData, capabilities: VideoConferenceCapabilities) throws -> Void
    func end() -> Void
    func viewWillTransition(to size: CGSize,
                            with coordinator: UIViewControllerTransitionCoordinator)
    
    var delegate: RNVideoConferenceViewControllerDelegate? { get set }
}
