//
//  UDUDUPushNotificationProcessorWrk.m
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDUPushNotificationProcessorWrk.h"
#import "UDDeviceIDHandlerProtocol.h"

@implementation UDUPushNotificationProcessorWrk

- (void) performActionForKey:(NSString *) key andObject:(id) object{
    if ([key isEqualToString:@"activation_code"]) {
        [self processActivationCode:object];
    }
    else if ([key isEqualToString:@"client_secret"]){
        [self processClientSecret:object];
    }
}

- (void) processActivationCode:(NSString *) activationCode{
    for (id observer in self.notificationObservers) {
        if ([observer conformsToProtocol:@protocol(UDDeviceIDHandlerProtocol) ]) {
            [observer activateDeviceWithActivationCode:activationCode];
        }
    }
}

- (void) processClientSecret:(NSString *) clientSecret{
    
}
@end
