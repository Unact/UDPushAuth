//
//  UDAppDelegate.m
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAppDelegate.h"   

@implementation UDAppDelegate
#pragma mark - Properties

#pragma mark - UIApplicationDelegate Implementation
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.pushNotificatonCenter = [UDPushNotificationCenter sharedPushNotificationCenter];
    self.authCodeRetriever = (UDPushAuthCodeRetriever *)[(UDAuthTokenRetriever *)[[UDOAuthBasic sharedOAuth] tokenRetriever] codeDelegate];
    self.reachability = [Reachability reachabilityWithHostname:[[UDOAuthBasic sharedOAuth] reachabilityServer]];
    self.reachability.reachableOnWWAN = YES;
    [self.reachability startNotifier];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
#if DEBUG
    NSLog(@"Device token: %@", deviceToken);
#endif
    [self.authCodeRetriever registerDeviceWithPushToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
#if DEBUG
	NSLog(@"Failed to get token, error: %@", error);
#endif
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{    
    [self.pushNotificatonCenter processPushNotification:userInfo];
}

@end

#if DEBUG
/*@implementation NSURLRequest(AllowAllCerts)

+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString *) host {
    return YES;
}
@end*/
#endif






