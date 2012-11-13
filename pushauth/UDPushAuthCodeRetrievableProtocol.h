//
//  UDDeviceIDHandlerProtocol.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDPushAuthCodeRetrievable <NSObject>
@property (nonatomic,readonly) NSString *deviceId;
- (void) registerDeviceWithPushToken:(NSData *) pushToken;
- (void) activateDeviceWithActivationCode:(NSString *) activationCode;
- (void) getAuthCode;
@end
