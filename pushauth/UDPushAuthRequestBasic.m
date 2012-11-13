//
//  UDPushAuthRequestBasic.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthRequestBasic.h"
#import "GDataXMLNode.h"

@implementation UDPushAuthRequestBasic
@synthesize uPushAuthServerURL = _uPushAuthServerURL;

- (NSString *) deviceType{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"ipad";
    }else{
        return @"iphone";
    }
}

- (void) registerDeviceWithPushToken:(NSString *)pushToken andCompleteonHandler:(void (^)(NSString *, BOOL))completeonHandler {
    NSURL *registerUrl = [self urlWithResouce:@"register" andParameters:[NSString stringWithFormat:@"push_token=%@&device_type=%@",pushToken,self.deviceType]];
    
    NSURLRequest * registerRequest = [NSURLRequest requestWithURL:registerUrl];
    
    [NSURLConnection sendAsynchronousRequest:registerRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"error %@",error);
            return;
        }
        
        GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (responseXML == nil) {
            NSLog(@"xml document error");
            return;
        }
        
        GDataXMLNode *deviceIDNode = [[responseXML nodesForXPath:@"/response/device_id" error:nil] lastObject];
        
        if (deviceIDNode == nil) {
            NSLog(@"xml node error");
            return;
        }
        
        completeonHandler(deviceIDNode.stringValue,NO);
    }];
    
}
- (void) activateDevice:(NSString *) deviceID WithActivationCode:(NSString *) activationCode CompleteonHandler:(void ( ^ ) (BOOL activationStatus)) completeonHandler{
    
}

- (void) authenticateDevice:(NSString *) deviceID WithCompleteonHandler:(void ( ^ ) (NSString *authCode)) completeonHandler{
    NSURL *registerUrl = [self urlWithResouce:@"auth" andParameters:[NSString stringWithFormat:@"client_id=&redirect_uri=upush://%@",deviceID]];
    
    NSURLRequest * registerRequest = [NSURLRequest requestWithURL:registerUrl];
    
    NSLog(@"%@",registerUrl);
    
    [NSURLConnection sendAsynchronousRequest:registerRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"error %@",error);
            return;
        }
        
        GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (responseXML == nil) {
            NSLog(@"xml document error");
            return;
        }
        
        GDataXMLNode *authCodeNode = [[responseXML nodesForXPath:@"/response/auth_code" error:nil] lastObject];
        
        if (authCodeNode == nil) {
            NSLog(@"xml node error");
            return;
        }
        
        completeonHandler(authCodeNode.stringValue);
    }];
    
}

- (NSURL *) urlWithResouce:(NSString *)resource andParameters:(NSString *) parameters{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",self.uPushAuthServerURL];
    urlString = [urlString stringByAppendingPathComponent:resource];
    urlString = [urlString stringByAppendingFormat:@"?%@",parameters];
    
    return [NSURL URLWithString:urlString];
}

@end
