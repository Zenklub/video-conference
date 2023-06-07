#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RNVideoConference, RCTEventEmitter)
RCT_EXTERN_METHOD(end)
RCT_EXTERN_METHOD(start:(NSDictionary)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
@end
