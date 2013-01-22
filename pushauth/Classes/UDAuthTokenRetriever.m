//
//  UDAuthTokenRetriever.m
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthTokenRetriever.h"
#import "UDPushAuthCodeRetriever.h"
#import "GDataXMLNode.h"

#define DEFAULT_TOKEN_LIFETIME 36000

@implementation UDAuthTokenRetriever
- (void) performTokenRequestWithAuthCode:(NSString *)authCode andRedirectURI:(NSString *)redirectURI{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",self.authServiceURI];
    urlString = [urlString stringByAppendingFormat:@"?_host=hqvsrv73&_svc=a/uoauth/auth&%@",[NSString stringWithFormat:@"e_service=upushauth&client_id=test&e_code=%@&redirect_uri=%@",authCode,redirectURI]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"auth error %@",error);
            return;
        }
        
        GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (responseXML == nil) {
            NSLog(@"xml document error");
            return;
        }
        
        NSDictionary *xmlns = [NSDictionary dictionaryWithObject:@"http://unact.net/xml/oauth" forKey:@"oauth"];
        
        GDataXMLNode *accessTokenValue = nil;
        
        if ([responseXML nodesForXPath:@"oauth:response/oauth:access-token" namespaces:xmlns error:nil].count > 0) {
             accessTokenValue = [[responseXML nodesForXPath:@"oauth:response/oauth:access-token" namespaces:xmlns error:nil] objectAtIndex:0];
        }
        
        if (accessTokenValue == nil) {
            NSLog(@"xml node error");
            
            return;
        }
        
        UDAuthToken * accessToken = [[UDAuthToken alloc] init];
        accessToken.value = accessTokenValue.stringValue;
        accessToken.lifetime = DEFAULT_TOKEN_LIFETIME;
        
        [weakSelf tokenReceived:accessToken];
    }];
}

+ (id) tokenRetriever{
    UDAuthTokenRetriever *tokenRetriever = [[self alloc] init];
    tokenRetriever.codeDelegate = [UDPushAuthCodeRetriever codeRetriever];
    return tokenRetriever;
}
@end
