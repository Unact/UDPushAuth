//
//  UDOAuthBasic.m
//  pushauth
//
//  Created by kovtash on 21.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDOAuthBasicAbstract.h"
#import "UDAuthToken.h"
#import "UDAuthTokenRetrievable.h"
#import "Reachability.h"

#define FORCED_TOKEN_CHECK_INTERVAL 20
#define TOKEN_CHECK_INTERVAL 300 //sec
#define TOKEN_ACTIVE_LIFETIME 28800 //sec

@interface UDOAuthBasicAbstract()
@property (strong,nonatomic) UDAuthToken *refreshToken;
@property (strong,nonatomic) NSString *clientSecret;
@end

@implementation UDOAuthBasicAbstract

- (NSString *) tokenValue{
    if (self.authToken != nil && self.authToken.isValid){
        return self.authToken.value;
    }
    else{
        return nil;
    }
}

- (void) setClientSecret:(NSString *)clientSecret{
    if (_clientSecret != clientSecret) {
        _clientSecret = clientSecret;
    }
}

- (void) setTokenRetriever:(id<UDAuthTokenRetrievable>)tokenRetriever{
    if (_tokenRetriever != tokenRetriever) {
        _tokenRetriever = tokenRetriever;
        if (self.tokenRetriever != nil) {
            [self.tokenRetriever setDelegate:self];
        }
    }
}

- (void) tokenReceived:(UDAuthToken *) token{
    if (token != nil ) {
        
        if (token.type == UDAccessTokenType && token != self.authToken) {
            _authToken = token;
            NSLog(@"Auth Token Received with ttl: %f",self.authToken.ttl);
        }
        else if (token.type == UDRefreshTokenType && token != self.refreshToken){
            self.refreshToken = token;
            NSLog(@"Refresh Token Received with ttl: %f",self.refreshToken.ttl);
        }
    }
}

- (void) forceTokenRequest{
    if (self.refreshToken != nil) {
        [self.tokenRetriever requestTokenWithRefreshToken:self.refreshToken.value ClientID:self.clientID ClientSecret:self.clientSecret];
    }
    else{
        [self.tokenRetriever requestToken];
    }
}

- (void) authCodeReceived:(NSString *)authCode forRedirectURI:(NSString *)redirectUri{
    [self.tokenRetriever requestTokenWithAuthCode:authCode ClientID:self.clientID ClientSecret:self.clientSecret];
}

- (void) checkToken{
    NSLog(@"Check token with ttl %f",self.authToken.ttl);
    
    if (self.authToken == nil || self.authToken.ttl < 1) {
            [NSTimer scheduledTimerWithTimeInterval:FORCED_TOKEN_CHECK_INTERVAL target:self selector:@selector(checkToken) userInfo:nil repeats:NO];
    }
    
    if ((self.authToken == nil || self.authToken.ttl < TOKEN_ACTIVE_LIFETIME) && [Reachability reachabilityWithHostname:self.reachabilityServer].isReachable) {
        [self forceTokenRequest];
    }
}

- (void) reachabilityChanged:(NSNotification *)notification{
    if ([notification.name isEqualToString: @"kReachabilityChangedNotification"]) {
        if ([[notification object] isReachable]) {
            [self checkToken];
        }
    }
}

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        self.tokenRetriever = [[self class] tokenRetrieverMaker];
        
        [NSTimer scheduledTimerWithTimeInterval:TOKEN_CHECK_INTERVAL target:self selector:@selector(checkToken) userInfo:nil repeats:YES];
        
        // here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    
    return self;    
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (id)sharedOAuth
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (NSString *) reachabilityServer{
    return nil;
}

+ (id) tokenRetrieverMaker{
    return nil;
}

@end
