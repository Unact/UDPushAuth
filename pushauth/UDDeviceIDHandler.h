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
#import "UDDeviceIDHandlerProtocol.h"

@interface UDDeviceIDHandler : NSObject <UDDeviceIDHandlerProtocol>
@property (strong,nonatomic) id <UDPushAuthHTTPProtocol> requestHandler;
@property (strong,nonatomic) id <UDPushAuthStorageProtocol> storage;
@end
