//
//  UDAuthToken.h
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDAuthToken : NSObject
@property (strong,nonatomic) NSString *value;
@property (assign,nonatomic) NSTimeInterval lifetime; //in seconds
@property (readonly,nonatomic) NSDate *creationTime;
@property (readonly,nonatomic) NSTimeInterval ttl;
@property (readonly,nonatomic) NSDate *expirationTime;
@property (readonly,nonatomic) BOOL isValid;
@end
