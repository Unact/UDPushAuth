//
//  UDAuthTokenRetrieverAbstract.m
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthTokenRetrieverAbstract.h"

@implementation UDAuthTokenRetrieverAbstract
@synthesize codeDelegate = _codeDelegate;
@synthesize delegate = _delegate;
@synthesize authServiceURI = _authServiceURI;

- (void) requestToken{
    [self.codeDelegate requestAuthCode];
}

- (void) authCodeReceived:(NSString *)authCode forRedirectURI:(NSString *)redirectUri{
    [self performTokenRequestWithAuthCode:authCode andRedirectURI:redirectUri];
}

- (void) tokenReceived:(UDAuthToken *)token{
    [self.delegate tokenReceived:token];
}

- (void) performTokenRequestWithAuthCode:(NSString *)authCode andRedirectURI:(NSString *)redirectURI{
    NSLog(@"Auth Code: %@ %@", authCode, redirectURI);
}
@end
