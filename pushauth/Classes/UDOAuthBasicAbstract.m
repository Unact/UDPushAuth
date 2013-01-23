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
@property (strong,nonatomic) UDAuthToken * authToken;
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

- (void) setTokenRetriever:(id<UDAuthTokenRetrievable>)tokenRetriever{
    if (_tokenRetriever != tokenRetriever) {
        _tokenRetriever = tokenRetriever;
        if (self.tokenRetriever != nil) {
            [self.tokenRetriever setDelegate:self];
        }
    }
}

- (void) tokenReceived:(UDAuthToken *) token{    
    if (token != nil && token != self.authToken) {
        self.authToken = token;
        
        NSLog(@"Token Received with ttl: %f",self.authToken.ttl);
    }
}

- (void) forceTokenRequest{
    [self.tokenRetriever requestToken];
}

- (void) checkToken{
    NSLog(@"Check token with ttl %f",self.authToken.ttl);
    
    if (self.authToken == nil || self.authToken.ttl < 1) {
            [NSTimer scheduledTimerWithTimeInterval:FORCED_TOKEN_CHECK_INTERVAL target:self selector:@selector(checkToken) userInfo:nil repeats:NO];
    }
    
    if ((self.authToken == nil || self.authToken.ttl < TOKEN_ACTIVE_LIFETIME) && [Reachability reachabilityWithHostname:self.reachabilityServer].isReachable) {
        [self.tokenRetriever requestToken];
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
