//
//  RNVideoConferenceViewController.swift
//  react-native-video-conference
//
//  Created by Erick on 14/09/22.
//

import UIKit

@objc(RNVideoConferenceViewController)
class RNVideoConferenceViewController: UIViewController {
    

    fileprivate let videoConference: VideoConferenceView = JitsiVideoConferenceView()
    
    @objc var rnView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rnView = rnView else {
            print("[RNVideoConference]: rnView was not set")
            return
        }
        
        view.addSubview(rnView)
    }
    
    func end() {
        videoConference.end()
        EventEmitter.sharedInstance.dispatch(event: .conferenceTerminated, body: {})
    }
    
    func start(with options: NSDictionary) throws {
        if options["room"] == nil {
            throw RNVideoConferenceError.missingRoom
        }
        
        guard let userInfo = options["userInfo"] as? NSDictionary else {
            throw RNVideoConferenceError.missingRoom
        }
        videoConference.delegate = self
        try videoConference.start(
            with: VideoConferenceOptions.from(dictionary: options),
            userData: UserData.from(dictionary: userInfo),
            capabilities: VideoConferenceCapabilities.from(dictionary: options["capabilities"] as? NSDictionary)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rnView?.frame = self.view.bounds
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        videoConference.viewWillTransition(to: size, with: coordinator)
    }
}


extension RNVideoConferenceViewController: RNVideoConferenceViewControllerDelegate {
    func ready(toClose data: [AnyHashable : Any]!) {
        EventEmitter.sharedInstance.dispatch(event: .readyToClose, body: data)
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        EventEmitter.sharedInstance.dispatch(event: .enterPictureInPicture, body: data)
    }

    func conferenceJoined(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .conferenceJoined, body: data)
    }

    func conferenceTerminated(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .conferenceTerminated, body: data)
    }

    func conferenceWillJoin(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .conferenceWillJoin, body: data)
    }

    func enterPictureInPicture(data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .enterPictureInPicture, body: data)
    }

    func participantJoined(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .participantJoined, body: data)
    }

    func participantLeft(data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .participantLeft, body: data)
    }

    func audioMutedChanged(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .audioMutedChanged, body: data)
    }

    func endpointTextMessageReceived(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .endpointTextMessageReceived, body: data)
    }

    func screenShareToggled(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .screenShareToggled, body: data)
    }

    func chatMessageReceived(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .chatMessageReceived, body: data)
    }

    func chatToggled(data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .chatToggled, body: data)
    }

    func videoMutedChanged(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .videoMutedChanged, body: data)
    }

    func readyToClose(data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .readyToClose, body: data)
        
    }
}
