//
//  UDAppDelegate.h
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDPushNotificationCenter.h"
#import "UDPushAuthCodeRetriever.h"
#import "UDAuthTokenRetriever.h"
#import "UDOAuthBasic.h"
#import "Reachability.h"

@interface UDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UDPushNotificationCenter *pushNotificatonCenter;
@property (strong, nonatomic) UDPushAuthCodeRetriever *authCodeRetriever;
@property (strong, nonatomic) Reachability *reachability;
@end
