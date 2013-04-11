//
//  UDOAuthBasic.m
//  pushauth
//
//  Created by kovtash on 22.01.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import "UDOAuthBasic.h"
#define TOKEN_SERVER_URL @"system.unact.ru"
#define AUTH_SERVICE_URI @"https://uoauth.unact.ru/a/UPushAuth/"

@implementation UDOAuthBasic

- (NSString *) reachabilityServer{
    return TOKEN_SERVER_URL;
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
    return @"websystem";
}

+ (id) tokenRetrieverMaker{
    UDAuthTokenRetriever *tokenRetriever = [[UDAuthTokenRetriever alloc] init];
    tokenRetriever.authServiceURI = [NSURL URLWithString:AUTH_SERVICE_URI];
    
    UDPushAuthCodeRetriever *codeRetriever = [UDPushAuthCodeRetriever codeRetriever];
    codeRetriever.requestDelegate.uPushAuthServiceURI = [NSURL URLWithString:AUTH_SERVICE_URI];
#if DEBUG
    [(UDPushAuthRequestBasic *)[codeRetriever requestDelegate] setConstantGetParameters:@"app_id=pushauth-dev"];
#else
    [(UDPushAuthRequestBasic *)[codeRetriever requestDelegate] setConstantGetParameters:@"app_id=pushauth"];
#endif
    tokenRetriever.codeDelegate = codeRetriever;
    
    return tokenRetriever;
}

@end
