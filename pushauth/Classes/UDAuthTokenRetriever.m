//
//  UDAuthTokenRetriever.m
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthTokenRetriever.h"
#import "UDPushAuthCodeRetriever.h"
#import "GDataXMLNode.h"

#define DEFAULT_ACCESS_TOKEN_LIFETIME 3600
#define DEFAULT_REFRESH_TOKEN_LIFETIME 3600*24*30

@implementation UDAuthTokenRetriever
- (void) performTokenRequestWithAuthCode:(NSString *)authCode andRedirectURI:(NSString *)redirectURI{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",self.authServiceURI];
    urlString = [urlString stringByAppendingFormat:@"?_host=hqvsrv73&_svc=a/uoauth/auth&%@",[NSString stringWithFormat:@"e_service=upushauth&client_id=test&e_code=%@&redirect_uri=%@",authCode,redirectURI]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        [weakSelf processTokenResponse:response Data:data Error:error];
    }];
}

- (void) requestTokenWithAuthCode:(NSString *) code ClientID:(NSString *) clientID ClientSecret:(NSString *) clientSecret{
    NSString *urlString = [NSString stringWithFormat:@"%@?_host=hqvsrv73&_svc=a/uoauth/token",self.authServiceURI];
    NSString *requestPOSTParameters = [NSString stringWithFormat:@"client_id=%@&code=%@&client_secret=%@",clientID,code,clientSecret];
    
    urlString = [urlString stringByAppendingFormat:@"&%@",requestPOSTParameters];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    /*NSData *requestPOSTData = [NSData dataWithBytes: [requestPOSTParameters UTF8String] length: [requestPOSTParameters length]];
     [request setHTTPMethod: @"POST"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
     [request setHTTPBody: requestPOSTData];*/
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        [weakSelf processTokenResponse:response Data:data Error:error];
    }];
}

- (void) requestTokenWithRefreshToken:(NSString *) refreshToken ClientID:(NSString *) clientID ClientSecret:(NSString *) clientSecret{
    NSString *urlString = [NSString stringWithFormat:@"%@?_host=hqvsrv73&_svc=a/uoauth/token",self.authServiceURI];
    NSString *requestPOSTParameters = [NSString stringWithFormat:@"client_id=%@&refresh_token=%@&client_secret=%@",clientID,refreshToken,clientSecret];
    
    urlString = [urlString stringByAppendingFormat:@"&%@",requestPOSTParameters];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    /*NSData *requestPOSTData = [NSData dataWithBytes: [requestPOSTParameters UTF8String] length: [requestPOSTParameters length]];
     [request setHTTPMethod: @"POST"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
     [request setHTTPBody: requestPOSTData];*/
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        [weakSelf processTokenResponse:response Data:data Error:error];
    }];
}

- (void) processTokenResponse:(NSURLResponse *) response Data:(NSData *) data Error:(NSError *) error{
    if (error != nil) {
        NSLog(@"auth error %@",error);
        return;
    }
    
    NSLog(@"");
    
    GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    if (responseXML == nil) {
        NSLog(@"xml document error");
        return;
    }
    
    NSDictionary *xmlns = [NSDictionary dictionaryWithObject:@"http://unact.net/xml/oauth" forKey:@"oauth"];
    
    GDataXMLNode *accessTokenValue = nil;
    
    
    if ([responseXML nodesForXPath:@"oauth:response/oauth:access-token" namespaces:xmlns error:nil].count > 0) {
        accessTokenValue = [[responseXML nodesForXPath:@"oauth:response/oauth:access-token" namespaces:xmlns error:nil] objectAtIndex:0];
    }
    
    if (accessTokenValue != nil) {
        UDAuthToken * accessToken = [UDAuthToken accessTokenWithWalue:accessTokenValue.stringValue Lifetime:DEFAULT_ACCESS_TOKEN_LIFETIME];
        
        [self tokenReceived:accessToken];
    }
    
    GDataXMLNode *refreshTokenValue = nil;
    
    if ([responseXML nodesForXPath:@"oauth:response/oauth:refresh-token" namespaces:xmlns error:nil].count > 0) {
        refreshTokenValue = [[responseXML nodesForXPath:@"oauth:response/oauth:refresh-token" namespaces:xmlns error:nil] objectAtIndex:0];
    }
    
    if (refreshTokenValue != nil){
        UDAuthToken * refreshToken = [UDAuthToken refreshTokenWithWalue:refreshTokenValue.stringValue Lifetime:DEFAULT_REFRESH_TOKEN_LIFETIME];
        [self tokenReceived:refreshToken];
    }
}

+ (id) tokenRetriever{
    UDAuthTokenRetriever *tokenRetriever = [[self alloc] init];
    tokenRetriever.codeDelegate = [UDPushAuthCodeRetriever codeRetriever];
    return tokenRetriever;
}
@end
