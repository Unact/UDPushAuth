//
//  UDOAuthBasic.m
//  pushauth
//
//  Created by kovtash on 22.01.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import "UDOAuthBasic.h"

#define CLIENT_ID @"websystem"
#define PUSHAUTH_SERVICE_URI @"https://uoauth.unact.ru/a/UPushAuth/"
#define AUTH_SERVICE_URI @"https://uoauth.unact.ru/a/uoauth/"
#define REACHABILITY_SERVER  @"uoauth.unact.ru"

@implementation UDOAuthBasic

- (NSString *) reachabilityServer{
    return REACHABILITY_SERVER;
}

- (NSURLRequest *) authenticateRequest:(NSURLRequest *)request{
    NSMutableURLRequest *resultingRequest = nil;
    
    if (self.tokenValue != nil) {
        resultingRequest = [request mutableCopy];
        [resultingRequest addValue:[NSString stringWithFormat:@"Bearer %@",self.tokenValue] forHTTPHeaderField:@"Authorization"];
    }
    
    return resultingRequest;
}

- (NSString *) clientID {
    return CLIENT_ID;
}

+ (id) tokenRetrieverMaker{
    UDAuthTokenRetriever *tokenRetriever = [[UDAuthTokenRetriever alloc] init];
    tokenRetriever.authServiceURI = [NSURL URLWithString:AUTH_SERVICE_URI];
    
    UDPushAuthCodeRetriever *codeRetriever = [UDPushAuthCodeRetriever codeRetriever];
    codeRetriever.requestDelegate.uPushAuthServiceURI = [NSURL URLWithString:PUSHAUTH_SERVICE_URI];
#if DEBUG
    [(UDPushAuthRequestBasic *)[codeRetriever requestDelegate] setConstantGetParameters:@"app_id=pushauth-dev"];
#else
    [(UDPushAuthRequestBasic *)[codeRetriever requestDelegate] setConstantGetParameters:@"app_id=pushauth"];
#endif
    tokenRetriever.codeDelegate = codeRetriever;
    
    return tokenRetriever;
}

@end
