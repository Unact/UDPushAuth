//
//  UDDeviceIDHandler.m
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthCodeRetrieverAbstract.h"

@interface UDPushAuthCodeRetrieverAbstract()
@end

@implementation UDPushAuthCodeRetrieverAbstract

#pragma mark -
#pragma mark *** UDDeviceIDHandlerProtocol ***
#pragma mark -

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

+ (id) codeRetriever{
    return [[UDPushAuthCodeRetrieverAbstract alloc] init];
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (NSString *) cleanPushToken:(NSData *) pushToken{
    NSString *resultToken = nil;
    
    resultToken = [NSString stringWithFormat:@"%@",pushToken];
    resultToken = [resultToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    resultToken = [resultToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return resultToken;
}

@end
