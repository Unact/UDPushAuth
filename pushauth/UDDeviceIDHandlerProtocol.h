//
//  UDDeviceIDHandlerProtocol.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDDeviceIDHandlerProtocol <NSObject>
@property (nonatomic,readonly) NSString *deviceId;
- (void) registerDevice;
- (void) activateDeviceWithActivationCode:(NSString *) activationCode;
@end
