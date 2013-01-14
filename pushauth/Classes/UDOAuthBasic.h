//
//  UDOAuthBasic.h
//  pushauth
//
//  Created by kovtash on 21.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDTokenRetrieverDelegate.h"

@interface UDOAuthBasic : NSObject <UDTokenRetrieverDelegate>
- (void) forceTokenRequest;
- (NSURLRequest *) authenticateRequest:(NSURLRequest *) request;
- (void) checkToken;
- (void) reachabilityChanged:(NSNotification *)notification;
+ (id)sharedOAuth;
@end
