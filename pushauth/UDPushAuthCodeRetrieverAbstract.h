//
//  UDDeviceIDHandler.h
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPushAuthRequestDelegate.h"
#import "UDPushAuthStorageDelegate.h"
#import "UDPushAuthCodeRetrievableProtocol.h"

@interface UDPushAuthCodeRetrieverAbstract : NSObject <UDPushAuthCodeRetrievable>
@property (strong,nonatomic) id <UDPushAuthRequestDelegate> requestDelegate;
@property (strong,nonatomic) id <UDPushAuthStorageDelegate> storageDelegate;
@end
