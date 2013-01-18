UDPushAuth
==========

Использование
---

`[[UDOAuthBasic sharedOAuth] authenticateRequest:(NSURLRequest *) request]` -
Возвращает аутентифицированный NSURLRequest или nil, если аутентификация невозможна.

Установка
---
```pod 'UDPushAuth', :git => 'https://github.com/Unact/UDPushAuth.git', :branch => 'master'```

Настройка
---
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.pushNotificatonCenter = [UDPushNotificationCenter sharedPushNotificationCenter];
    self.authCodeRetriever = [UDPushAuthCodeRetriever codeRetriever];
    
    [UDOAuthBasic sharedOAuth];
    
    // allocate a reachability object
    self.reachability = [Reachability reachabilityWithHostname:@"{hostname_to_check}"];
    self.reachability.reachableOnWWAN = YES;
    
    [self.reachability startNotifier];
    
    return YES;
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
```


