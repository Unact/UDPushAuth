//
//  UDPushAuthStorageProtocol.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDPushAuthStorageProtocol <NSObject>
@property (strong,nonatomic) NSString *deviceID;
@property (strong,nonatomic) NSString *accessToken;
@end
