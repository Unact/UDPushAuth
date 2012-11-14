//
//  UDAuthCodeRetrieverDelegate.h
//  pushauth
//
//  Created by kovtash on 14.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDAuthCodeRetrieverDelegate <NSObject>
- (void) authCodeRecived:(NSString *) authCode;
@end
