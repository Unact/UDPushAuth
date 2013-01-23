//
//  UDOAuthBasic.h
//  pushauth
//
//  Created by kovtash on 21.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDTokenRetrieverDelegate.h"
#import "UDAuthTokenRetrievable.h"

@interface UDOAuthBasicAbstract : NSObject <UDTokenRetrieverDelegate>
@property (strong,nonatomic) id <UDAuthTokenRetrievable> tokenRetriever;
@property (readonly,nonatomic) NSString *reachabilityServer;
@property (readonly,nonatomic) NSString *tokenValue;
- (void) forceTokenRequest;
- (void) checkToken;
- (void) reachabilityChanged:(NSNotification *)notification;
+ (id)sharedOAuth;
+ (id) tokenRetrieverMaker;
@end
