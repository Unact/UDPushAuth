//
//  UDPushNotificationCenter.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationCenter.h"
#import "UDPushNotificationCenterAbstract.h"
#import "UDUPushNotificationProcessorBasic.h"
#import "UDUPushNotificationProcessorWrk.h"

@implementation UDPushNotificationCenter
+ (id) pushNotificationCenter{
    UDPushNotificationCenterAbstract *pushNotificationCenter = [[UDPushNotificationCenterAbstract alloc] init];
#if DEBUG
    [pushNotificationCenter addPushNotificationProcessor:[[UDUPushNotificationProcessorBasic alloc] init]];
#endif
    
    [pushNotificationCenter addPushNotificationProcessor:[[UDUPushNotificationProcessorWrk alloc] init]];
    
    return pushNotificationCenter;
}
@end
