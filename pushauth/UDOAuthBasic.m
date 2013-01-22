//
//  UDOAuthBasic.m
//  pushauth
//
//  Created by kovtash on 22.01.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import "UDOAuthBasic.h"
#define TOKEN_SERVER_URL @"system.unact.ru"
#define AUTH_SERVICE_URI @"https://system.unact.ru/asa"

@implementation UDOAuthBasic

- (NSString *) reachabilityServer{
    return TOKEN_SERVER_URL;
}

+ (id) tokenRetrieverMaker{
    UDAuthTokenRetriever *tokenRetriever = [[UDAuthTokenRetriever alloc] init];
    tokenRetriever.authServiceURI = [NSURL URLWithString:AUTH_SERVICE_URI];
    
    UDPushAuthCodeRetriever *codeRetriever = [UDPushAuthCodeRetriever codeRetriever];
    codeRetriever.requestDelegate.uPushAuthServiceURI = [NSURL URLWithString:AUTH_SERVICE_URI];
#if DEBUG
    [(UDPushAuthRequestBasic *)[codeRetriever requestDelegate] setConstantGetParameters:@"_host=hqvsrv73&app_id=pushauth-dev&_svc=a/UPushAuth/"];
#else
    [(UDPushAuthRequestBasic *)[codeRetriever requestDelegate] setConstantGetParameters:@"_host=hqvsrv73&app_id=pushauth&_svc=a/UPushAuth/"];
#endif
    tokenRetriever.codeDelegate = codeRetriever;
    
    return tokenRetriever;
}

@end
