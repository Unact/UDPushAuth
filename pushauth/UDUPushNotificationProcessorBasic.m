//
//  UDPushNotificationProcessorUNProtocol.m
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDUPushNotificationProcessorBasic.h"

#define UN_PROTO_BLOCK_KEY @"unact"

@implementation UDUPushNotificationProcessorBasic

@synthesize notificationObservers = _notificationObservers;

- (void) processPushNotification:(NSDictionary *)userInfo{
    NSDictionary *unProtocolMessageBlock = [userInfo objectForKey:UN_PROTO_BLOCK_KEY];
    
    if (unProtocolMessageBlock != nil && [unProtocolMessageBlock isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in unProtocolMessageBlock.allKeys) {
            [self performActionForKey:key andObject:[unProtocolMessageBlock objectForKey:key]];
        }
    }
}

- (void) performActionForKey:(NSString *) key andObject:(id) object{
    NSLog(@"%@ : %@",key,object);
}

@end
