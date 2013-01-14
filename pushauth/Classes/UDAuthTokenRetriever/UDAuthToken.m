//
//  UDAuthToken.m
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthToken.h"

@interface UDAuthToken()
@property (nonatomic,strong) NSDate *privateCreationTime;
@end

@implementation UDAuthToken

- (NSDate *) creationTime{
    return self.privateCreationTime;
}

- (NSDate *) expirationTime{
    return [NSDate dateWithTimeInterval:self.lifetime sinceDate:self.privateCreationTime];
}

- (NSTimeInterval) ttl{
    return [self.expirationTime timeIntervalSinceDate:[NSDate date]];
}

- (BOOL) isValid{
    if (self.ttl > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (id) init{
    
    self = [super init];
    
    if (self != nil) {
        self.privateCreationTime = [NSDate date];
    }
    
    return self;
}

@end
