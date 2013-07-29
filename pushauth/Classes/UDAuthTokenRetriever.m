//
//  UDAuthTokenRetriever.m
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthTokenRetriever.h"
#import "UDPushAuthCodeRetriever.h"

#define DEFAULT_ACCESS_TOKEN_LIFETIME 3600
#define DEFAULT_REFRESH_TOKEN_LIFETIME 3600*24*30

@implementation UDAuthTokenRetriever
- (void) performTokenRequestWithAuthCode:(NSString *)authCode andRedirectURI:(NSString *)redirectURI{
    NSString *requestParameters = [NSString stringWithFormat:@"e_service=upushauth&client_id=test&e_code=%@&redirect_uri=%@",authCode,redirectURI];
    NSURLRequest * request = [self requestWithResource:@"auth" Parameters:requestParameters];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
                               if ([weakSelf respondsToSelector:@selector(processTokenResponse:Data:Error:)]) {
                                   [weakSelf processTokenResponse:response Data:data Error:error];
                               }
                           }];
}

- (void) requestTokenWithAuthCode:(NSString *) code ClientID:(NSString *) clientID ClientSecret:(NSString *) clientSecret{
    NSString *requestParameters = [NSString stringWithFormat:@"client_id=%@&code=%@&client_secret=%@",clientID,code,clientSecret];
    NSURLRequest * request = [self requestWithResource:@"token" Parameters:requestParameters];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
                               if ([weakSelf respondsToSelector:@selector(processTokenResponse:Data:Error:)]) {
                                   [weakSelf processTokenResponse:response Data:data Error:error];
                               }
                           }];
}

- (void) requestTokenWithRefreshToken:(NSString *) refreshToken ClientID:(NSString *) clientID ClientSecret:(NSString *) clientSecret{
    NSString *requestParameters = [NSString stringWithFormat:@"client_id=%@&refresh_token=%@&client_secret=%@",clientID,refreshToken,clientSecret];
    NSURLRequest * request = [self requestWithResource:@"token" Parameters:requestParameters];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
                               if ([weakSelf respondsToSelector:@selector(processTokenResponse:Data:Error:)]) {
                                   [weakSelf processTokenResponse:response Data:data Error:error];
                               }
                           }];
}

- (void) processTokenResponse:(NSURLResponse *) response Data:(NSData *) data Error:(NSError *) error{
    if (error != nil) {
        NSLog(@"auth error %@",error);
        return;
    }
    
    NSError *parseError= nil;
    
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData: data
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &parseError];
    if (parseError) {
        NSLog(@"Error parsing JSON %@",parseError.description);
        return;
    }
    
    NSDictionary *accessTokenData = [responseData objectForKey:@"accessToken"];
    NSDictionary *refreshTokenData = [responseData objectForKey:@"refreshToken"];
    
    if (accessTokenData != nil) {
        UDAuthToken * accessToken = [self tokenFromDict:accessTokenData
                                               withType:UDAccessTokenType
                                        defaultLifetime:DEFAULT_ACCESS_TOKEN_LIFETIME];
        [self tokenReceived:accessToken];
    }
    
    if (refreshTokenData != nil){
        UDAuthToken * refreshToken = [self tokenFromDict:refreshTokenData
                                                withType:UDRefreshTokenType
                                         defaultLifetime:DEFAULT_REFRESH_TOKEN_LIFETIME];
        [self tokenReceived:refreshToken];
    }
}

- (UDAuthToken *) tokenFromDict:(NSDictionary *) tokenData
                       withType:(UDTokenType) tokenType
                defaultLifetime:(NSTimeInterval) defaultLifetime{
    UDAuthToken *token = nil;
    if (tokenData != nil) {
        NSTimeInterval tokenLifetime = defaultLifetime;
        if (tokenData[@"expireAfter"]) {
            tokenLifetime = [(NSNumber *)tokenData[@"expireAfter"] doubleValue];
        }
        switch (tokenType) {
            case UDRefreshTokenType:
                token = [UDAuthToken refreshTokenWithWalue:tokenData[@"token"]
                                                  Lifetime:tokenLifetime];
                break;
            case UDAccessTokenType:
                token = [UDAuthToken accessTokenWithWalue:tokenData[@"token"]
                                                 Lifetime:tokenLifetime];
                break;
            default:
                break;
        }
    }
    return token;
}

+ (id) tokenRetriever{
    UDAuthTokenRetriever *tokenRetriever = [[self alloc] init];
    tokenRetriever.codeDelegate = [UDPushAuthCodeRetriever codeRetriever];
    return tokenRetriever;
}

- (NSURLRequest *) requestWithResource:(NSString *) resource Parameters:(NSString *) parameters{
    NSURL *url = [self.authServiceURI URLByAppendingPathComponent:resource];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *requestPOSTData = [NSData dataWithBytes: [parameters UTF8String] length: [parameters length]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestPOSTData];
    
    return request;
}
@end
