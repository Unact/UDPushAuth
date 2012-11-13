//
//  UDPushNotificationCenter.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationCenter.h"
#import "UDPushNotificationCenterAbstract.h"
#import "UDPushNotificationProcessorBasic.h"
#import "UDPushNotificationProcessor.h"

@implementation UDPushNotificationCenter
+ (id) pushNotificationCenter{
    UDPushNotificationCenterAbstract *pushNotificationCenter = [[UDPushNotificationCenterAbstract alloc] init];
#if DEBUG
    [pushNotificationCenter addPushNotificationProcessor:[UDPushNotificationProcessorBasic notificationProcessor]];
#endif
    
    [pushNotificationCenter addPushNotificationProcessor:[UDPushNotificationProcessor notificationProcessor]];
    
    return pushNotificationCenter;
}
@end
