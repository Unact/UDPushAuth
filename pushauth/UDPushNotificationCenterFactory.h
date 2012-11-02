//
//  UDPushNotificationCenterFactory.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPushNotificationCenter.h"
#import "UDUPushNotificationProcessorBasic.h"

@interface UDPushNotificationCenterFactory : NSObject
+ (UDPushNotificationCenter *) makePushNotificationCenter;
@end
