//
//  UDPushAuthStorageBasic.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthStorageBasic.h"
 
#define DEVICE_ID_KEY @"UDPushAuthDeviceIDBasic"
#define PUSH_TOKEN_KEY @"UDPushAuthTokenBasic"

@interface UDPushAuthStorageBasic()
@end

@implementation UDPushAuthStorageBasic
@synthesize deviceID = _deviceID;
@synthesize accessToken = _accessToken;

- (NSString *) deviceID{
    return [[NSUserDefaults standardUserDefaults] stringForKey:DEVICE_ID_KEY];
}

- (void) setDeviceID:(NSString *)deviceID{
    if (deviceID != nil && ![deviceID isEqualToString:self.deviceID]) {
        [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:DEVICE_ID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *) accessToken{
    return [[NSUserDefaults standardUserDefaults] stringForKey:PUSH_TOKEN_KEY];
}

- (void) setAccessToken:(NSString *)accessToken{
    if (accessToken != nil && ![accessToken isEqualToString:self.accessToken]) {
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:PUSH_TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
