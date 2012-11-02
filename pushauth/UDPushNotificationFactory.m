//
//  UDPushNotificationCenterFactory.m
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationFactory.h"

@implementation UDPushNotificationCenterFactory

+(UDPushNotificationCenter *)makePushNotificationCenter{
    UDPushNotificationCenter *pushNotificationCenter = [[UDPushNotificationCenter alloc] init];
    
    [pushNotificationCenter addPushNotificationProcessor:[[UDUPushNotificationProcessorBasic alloc] init]];
    [pushNotificationCenter addPushNotificationProcessor:[[UDUPushNotificationProcessorWrk alloc] init]];
    
    return pushNotificationCenter;
}

@end


@implementation UDDeviceIDHandlerFactory

+ (UDDeviceIDHandler *) makeDeviceIDHandler{
    UDDeviceIDHandler *deviceIDHandler = [[UDDeviceIDHandler alloc] init];
    
    
    return deviceIDHandler;
}

@end