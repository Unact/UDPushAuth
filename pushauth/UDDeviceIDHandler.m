//
//  UDDeviceIDHandler.m
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDDeviceIDHandler.h"

@interface UDDeviceIDHandler()
@end

@implementation UDDeviceIDHandler

#pragma mark - UDDeviceIDHandlerProtocol
@synthesize deviceId = _deviceId;

- (void) registerDevice{
    [self.requestHandler registerDeviceWithCompleteonHandler:^(NSString *deviceID, BOOL isActivated){
        if (deviceID!= nil && ![deviceID isEqualToString:self.storage.deviceID]) {
            self.storage.deviceID = deviceID;
        }
    }];
}

- (void) activateDeviceWithActivationCode:(NSString *) activationCode{
    if (self.storage.deviceID != nil && activationCode != nil) {
        [self.requestHandler activateDevice:self.storage.deviceID WithActivationCode:activationCode CompleteonHandler:^(BOOL activationStatus){
        
        }];
    }
}

@end
