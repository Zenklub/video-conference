//
//  JitsiMeetViewController.swift
//  react-native-video-conference
//
//  Created by Erick on 27/04/23.
//
import Foundation
import UIKit
import JitsiMeetSDK

class JitsiVideoConferenceView: UIView {
    fileprivate var conferenceOptions: JitsiMeetConferenceOptions?
    fileprivate var jitsiMeetView: JitsiMeetView?
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    
    var delegate: RNVideoConferenceViewControllerDelegate?
}


extension JitsiVideoConferenceView: VideoConferenceView {
    fileprivate func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
    }
    
    func end() {
        jitsiMeetView?.hangUp()
        cleanUp()
    }
    
    func start(with options: VideoConferenceOptions, userData: UserData, capabilities: VideoConferenceCapabilities) throws {
        let rootView = delegate?.view
        
        conferenceOptions = JitsiUtil
            .buildConferenceOptions(
                options: options,
                userData: userData,
                capabilities: capabilities
            )
        
        
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        
        // join room and display jitsi-call
        jitsiMeetView.join(conferenceOptions!)
        
        // Enable jitsimeet view to be a view that can be displayed
        // on top of all the things, and let the coordinator to manage
        // the view state and interactions
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: rootView)

        // animate in
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }
    
    func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {

        let rect = CGRect(origin: CGPoint.zero, size: size)
        // Reset view to provide bounds. It is required to do so
        // on rotation or screen size changes.
        pipViewCoordinator?.resetBounds(bounds: rect)
    }
}


extension JitsiVideoConferenceView: JitsiMeetViewDelegate {
    
    func ready(toClose data: [AnyHashable : Any]!) {
        self.pipViewCoordinator?.hide() { _ in
            self.cleanUp()
        }
        self.delegate?.ready(toClose: data)
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        self.pipViewCoordinator?.enterPictureInPicture()
        self.delegate?.enterPicture(inPicture: data)
    }
    
    func enterPictureInPicture(data: [AnyHashable : Any]) {
        self.delegate?.enterPictureInPicture(data: data)
    }
    
    func conferenceJoined(_ data: [AnyHashable : Any]) {
        self.delegate?.conferenceJoined(data)
    }

    func conferenceTerminated(_ data: [AnyHashable : Any]) {
        self.delegate?.conferenceTerminated(data)
    }

    func conferenceWillJoin(_ data: [AnyHashable : Any]) {
        self.delegate?.conferenceWillJoin(data)
    }

    func participantJoined(_ data: [AnyHashable : Any]) {
        self.delegate?.participantJoined(data)
    }

    func participantLeft(data: [AnyHashable : Any]) {
        self.delegate?.participantLeft(data: data)
    }

    func audioMutedChanged(_ data: [AnyHashable : Any]) {
        self.delegate?.audioMutedChanged(data)
    }

    func endpointTextMessageReceived(_ data: [AnyHashable : Any]) {
        self.delegate?.endpointTextMessageReceived(data)
    }

    func screenShareToggled(_ data: [AnyHashable : Any]) {
        self.delegate?.screenShareToggled(data)
    }

    func chatMessageReceived(_ data: [AnyHashable : Any]) {
        self.delegate?.chatMessageReceived(data)
    }

    func chatToggled(data: [AnyHashable : Any]) {
        self.delegate?.chatToggled(data: data)
    }

    func videoMutedChanged(_ data: [AnyHashable : Any]) {
        self.delegate?.videoMutedChanged(data)
    }

    func readyToClose(data: [AnyHashable : Any]) {
        self.delegate?.readyToClose(data: data)
    }
}
