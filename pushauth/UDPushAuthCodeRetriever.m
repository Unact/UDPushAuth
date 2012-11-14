//
//  UDPushAuthCodeRetriever.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthCodeRetriever.h"
#import "UDPushAuthRequestBasic.h"
#import "UDPushAuthStorageBasic.h"
#import "UDPushNotificationCenter.h"

#define AUTH_SERVER_URL @"https://hqvsrv73.unact.ru/a/UPushAuth"

@implementation UDPushAuthCodeRetriever
+ (id) codeRetriever{
    
    UDPushAuthCodeRetriever *codeRetriever = [[self alloc] init];
    codeRetriever.requestDelegate = [[UDPushAuthRequestBasic alloc] init];
    codeRetriever.storageDelegate = [[UDPushAuthStorageBasic alloc] init];
    
    codeRetriever.requestDelegate.uPushAuthServerURL = [NSURL URLWithString:AUTH_SERVER_URL];
    
    [[UDPushNotificationCenter sharedPushNotificationCenter] addObserver:codeRetriever];
    
    return codeRetriever;
}

- (void)dealloc{
    [[UDPushNotificationCenter sharedPushNotificationCenter] addObserver:self];
}
@end
