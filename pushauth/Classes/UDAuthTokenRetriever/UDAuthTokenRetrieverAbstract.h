//
//  UDAuthTokenRetrieverAbstract.h
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDAuthTokenRetrievable.h"
#import "UDAuthTokenProcessable.h"
#import "UDAuthCodeRetrieverDelegate.h"

@interface UDAuthTokenRetrieverAbstract : NSObject <UDAuthTokenRetrievable,UDAuthTokenProcessable,UDAuthCodeRetrieverDelegate>

@end
