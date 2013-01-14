//
//  UDPushAuthRequestBasic.h
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPushAuthRequestDelegate.h"

@interface UDPushAuthRequestBasic : NSObject <UDPushAuthRequestDelegate>
@property (readonly) NSString * deviceType;
@end