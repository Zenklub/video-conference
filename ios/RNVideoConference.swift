import UIKit

@objc(RNVideoConference)
class RNVideoConference: RCTEventEmitter {

    override init() {
        super.init()
        EventEmitter.sharedInstance.registerEventEmitter(eventEmitter: self)
    }

    override class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc func end(_ resolve: @escaping RCTPromiseResolveBlock, endFailed reject: RCTPromiseRejectBlock) {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController as? RNVideoConferenceViewController else {
            reject("END_VIDEO_CONFERENCE", "rootViewController should be RNVideoConferenceViewController", NSError())
            return
        }
        DispatchQueue.main.async {
            rootViewController.end()
            resolve(nil)
        }    
    }

    @objc func start(_ options: NSDictionary,
                     resolver resolve: @escaping RCTPromiseResolveBlock,
                     rejecter reject: @escaping RCTPromiseRejectBlock)
    {
        DispatchQueue.main.async {
            do {
                guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController as? RNVideoConferenceViewController else {
                    return reject("LAUNCH_VIDEO_CONFERENCE", "rootViewController should be RNVideoConferenceViewController", NSError())
                }
                
                try rootViewController.start(with: options)
                resolve(nil)
            } catch RNVideoConferenceError.missingRoom {
                let err = RNVideoConferenceError.missingRoom
                return reject(err.getCode(), err.getMessage(), err)
            } catch RNVideoConferenceError.rootViewNotFound {
                let err = RNVideoConferenceError.rootViewNotFound
                return reject(err.getCode(), err.getMessage(), err)
            } catch {
                return reject("LAUNCH_VIDEO_CONFERENCE", error.localizedDescription, error)
                
            }
        }
    }
    
    @objc open override func supportedEvents() -> [String] {
        return EventEmitter.sharedInstance.allEvents
    }
}
