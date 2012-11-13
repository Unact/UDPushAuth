//
//  UDPushNotificationCenterFactory.m
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationFactory.h"
#import "UDPushAuthRequestBasic.h"
#import "UDPushAuthStorageBasic.h"

#define AUTH_SERVER_URL @"https://hqvsrv73.unact.ru/a/UPushAuth"

@implementation UDPushNotificationCenterFactory

+(UDPushNotificationCenter *)makePushNotificationCenter{
    UDPushNotificationCenter *pushNotificationCenter = [[UDPushNotificationCenter alloc] init];
#if DEBUG
    [pushNotificationCenter addPushNotificationProcessor:[[UDUPushNotificationProcessorBasic alloc] init]];
#endif
    
    [pushNotificationCenter addPushNotificationProcessor:[[UDUPushNotificationProcessorWrk alloc] init]];
    
    return pushNotificationCenter;
}

@end


@implementation UDDeviceIDHandlerFactory

+ (UDPushAuthCodeRetriever *) makeDeviceIDHandler{
    UDPushAuthCodeRetriever *deviceIDHandler = [[UDPushAuthCodeRetriever alloc] init];
    deviceIDHandler.requestDelegate = [[UDPushAuthRequestBasic alloc] init];
    deviceIDHandler.storageDelegate = [[UDPushAuthStorageBasic alloc] init];
    
    deviceIDHandler.requestDelegate.uPushAuthServerURL = [NSURL URLWithString:AUTH_SERVER_URL];
    
    return deviceIDHandler;
}

@end