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
- (void) registerDevice;
- (void) activateDevice:(NSString *) deviceID withActivationCode:(NSString *) activationCode;
- (void) authenticateDevice:(NSString *) deviceID;
@end
