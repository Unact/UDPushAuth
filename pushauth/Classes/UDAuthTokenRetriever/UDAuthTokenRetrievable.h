//
//  UDAuthTokenRetrievable.h
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDTokenRetrieverDelegate.h"

@protocol UDAuthTokenRetrievable <NSObject>
@property (weak,nonatomic) id <UDTokenRetrieverDelegate> delegate;
- (void) requestToken;
@end
