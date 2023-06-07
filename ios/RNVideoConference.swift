import UIKit
import JitsiMeetSDK

@objc(RNVideoConference)
class RNVideoConference: RCTEventEmitter {

    override init() {
        super.init()
        EventEmitter.sharedInstance.registerEventEmitter(eventEmitter: self)
    }
    
    @objc func end(resolver resolve: @escaping RCTPromiseResolveBlock,
                      rejecter reject: @escaping RCTPromiseRejectBlock) {
 
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController as? RNVideoConferenceViewController else {
            reject("LAUNCH_VIDEO_CONFERENCE", "rootViewController should be RNVideoConferenceViewController", NSError())
            return
        }
        
        rootViewController.end()
        resolve(nil)

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
