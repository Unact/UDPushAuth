//
//  UDDeviceIDHandler.m
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthCodeRetriever.h"

@interface UDPushAuthCodeRetriever()
@end

@implementation UDPushAuthCodeRetriever

#pragma mark - UDDeviceIDHandlerProtocol
@synthesize deviceId = _deviceId;

- (void) registerDeviceWithPushToken:(NSData *)pushToken{
    
    __weak __typeof(&*self) weakSelf = self;
    
    [self.requestDelegate registerDeviceWithPushToken:[self cleanPushToken:pushToken] andCompleteonHandler:^(NSString *deviceID, BOOL isActivated){
            weakSelf.storageDelegate.deviceID = deviceID;
    }];
}

- (void) activateDeviceWithActivationCode:(NSString *) activationCode{
        
    if (self.storageDelegate.deviceID != nil && activationCode != nil) {
        [self.requestDelegate activateDevice:self.storageDelegate.deviceID WithActivationCode:activationCode CompleteonHandler:^(BOOL activationStatus){
        
        }];
    }
}

- (void) getAuthCode{
    
    NSLog(@"%@",self.storageDelegate.deviceID);
    
    if (self.storageDelegate.deviceID != nil) {
        [self.requestDelegate authenticateDevice:self.storageDelegate.deviceID WithCompleteonHandler:^(NSString *authCode){
        
            NSLog(@"authCode %@",authCode);
        }];
    }
}

- (NSString *) cleanPushToken:(NSData *) pushToken{
    NSString *resultToken = nil;
    
    resultToken = [NSString stringWithFormat:@"%@",pushToken];
    resultToken = [resultToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    resultToken = [resultToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return resultToken;
}

@end
