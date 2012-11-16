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

#define AUTH_SERVICE_URI @"https://hqvsrv73.unact.ru/a/uoauth"

@implementation UDAuthTokenRetriever
- (void) performTokenRequestWithAuthCode:(NSString *)authCode andRedirectURI:(NSString *)redirectURI{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",self.authServiceURI];
    urlString = [urlString stringByAppendingPathComponent:@"auth"];
    urlString = [urlString stringByAppendingFormat:@"?%@",[NSString stringWithFormat:@"e_service=upushauth&client_id=test&e_code=%@&redirect_uri=%@",authCode,redirectURI]];
    
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
        
        GDataXMLNode *accessTokenValue = [[responseXML nodesForXPath:@"oauth:response/oauth:access-token" namespaces:xmlns error:nil] objectAtIndex:0];
        
        if (accessTokenValue == nil) {
            NSLog(@"xml node error");
            
            return;
        }
        
        UDAuthToken * accessToken = [[UDAuthToken alloc] init];
        accessToken.value = accessTokenValue.stringValue;
        accessToken.lifetime = 14400; //4 hours
        
        [weakSelf tokenReceived:accessToken];
    }];
}

+ (id) tokenRetriever{
    
    UDAuthTokenRetriever *tokenRetriever = [[self alloc] init];
    tokenRetriever.authServiceURI = [NSURL URLWithString:AUTH_SERVICE_URI];
    
    tokenRetriever.codeDelegate = [UDPushAuthCodeRetriever codeRetriever];
    tokenRetriever.codeDelegate.codeDelegate = tokenRetriever;
    
    return tokenRetriever;
}
@end
