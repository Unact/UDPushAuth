//
//  UDUDUPushNotificationProcessorWrk.m
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationProcessor.h"
#import "UDPushAuthProcessableProtocol.h"

@implementation UDPushNotificationProcessor

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
        if ([observer conformsToProtocol:@protocol(UDPushAuthProcessable)]) {
            [observer activationCodeReceived:activationCode];
        }
    }
}

- (void) processClientSecret:(NSDictionary *) clientSecret{
    for (id observer in self.notificationObservers) {
        
        if ([clientSecret objectForKey:@"value"] != nil && [clientSecret objectForKey:@"id"] != nil) {
            if ([observer conformsToProtocol:@protocol(UDPushAuthProcessable)]) {
                [observer clientSecretReceived:[clientSecret objectForKey:@"value"] withID:[clientSecret objectForKey:@"id"]];
            }
        }
        else {
            NSLog(@"client_secret format error");
        }
    }
}
@end
