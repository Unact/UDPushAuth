//
//  UDPushNotificationCenterFactory.m
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationCenterFactory.h"

@implementation UDPushNotificationCenterFactory

+(UDPushNotificationCenter *)makePushNotificationCenter{
    UDPushNotificationCenter *pushNotificationCenter = [[UDPushNotificationCenter alloc] init];
    
    [pushNotificationCenter addPushNotificationProcessor:[[UDUPushNotificationProcessorBasic alloc] init]];
    
    return pushNotificationCenter;
}


@end
