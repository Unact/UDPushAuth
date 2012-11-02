//
//  UDDeviceIDHandler.h
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPushAuthHTTPProtocol.h"
#import "UDPushAuthStorageProtocol.h"

@interface UDDeviceIDHandler : NSObject
@property (strong,nonatomic) NSString *deviceId;
@property (strong,nonatomic) id <UDPushAuthHTTPProtocol> requestHandler;
@property (strong,nonatomic) id <UDPushAuthStorageProtocol> storage;
- (void) registerDevice;
- (void) activateDeviceWithActivationCode:(NSString *) activationCode;
@end
