//
//  UDPushAuthHTTPProtocol.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDPushAuthHTTPProtocol <NSObject>
@property (strong,nonatomic) NSURL *uPushAuthServerURL;
- (void) registerDeviceWithCompleteonHandler:(void ( ^ ) (NSString *deviceID, BOOL isActivated)) completeonHandler;
- (void) activateDevice:(NSString *) deviceID WithActivationCode:(NSString *) activationCode CompleteonHandler:(void ( ^ ) (BOOL activationStatus)) completeonHandler;
- (void) authenticateDevice:(NSString *) deviceID WithCompleteonHandler:(void ( ^ ) (NSString *authCode)) completeonHandler;
@end
