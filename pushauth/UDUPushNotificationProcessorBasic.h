//
//  UDPushNotificationProcessorUNProtocol.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPushNotificationProcessable.h"

@interface UDUPushNotificationProcessorBasic : NSObject <UDPushNotificationProcessable>
- (void) performActionForKey:(NSString *) key andObject:(id) object;
@end
