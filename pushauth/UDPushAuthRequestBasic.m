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
@synthesize uPushAuthServiceURI = _uPushAuthServiceURI;

- (NSString *) deviceType{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"ipad";
    }else{
        return @"iphone";
    }
}

- (void) registerDeviceWithPushToken:(NSString *)pushToken andCompleteonHandler:(void (^)(NSString *, BOOL))completeonHandler {
    NSURL *url = [self urlWithResouce:@"register" andParameters:[NSString stringWithFormat:@"push_token=%@&device_type=%@",pushToken,self.deviceType]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
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
    NSURL *url = [self urlWithResouce:@"activate" andParameters:[NSString stringWithFormat:@"device_id=%@&activation_code=%@",deviceID,activationCode]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"activate error %@",error);
            return;
        }
        
        GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (responseXML == nil) {
            NSLog(@"xml document error");
            return;
        }
        
        GDataXMLNode *authCodeNode = [[responseXML nodesForXPath:@"/response/activate" error:nil] lastObject];
        
        if (authCodeNode == nil) {
            NSLog(@"xml node error");
            completeonHandler(NO);
            return;
        }
        
        if ([authCodeNode.stringValue isEqualToString:@"yes"]) {
            completeonHandler(YES);
        }
        else{
            completeonHandler(NO);
        }
        
    }];
    
}

- (void) authenticateDevice:(NSString *) deviceID WithCompleteonHandler:(void ( ^ ) (NSString *authCode, NSString *codeIdentifier)) completeonHandler{
    NSURL *url = [self urlWithResouce:@"auth" andParameters:[NSString stringWithFormat:@"client_id=test&redirect_uri=upush://%@",deviceID]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
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
        
        GDataXMLNode *authCodeNode = [[responseXML nodesForXPath:@"/response/code" error:nil] lastObject];
        GDataXMLNode *authCodeIDNode = [[responseXML nodesForXPath:@"/response/id" error:nil] lastObject];
        
        if (authCodeNode == nil) {
            NSLog(@"xml node error");
            return;
        }
        
        completeonHandler(authCodeNode.stringValue,authCodeIDNode.stringValue);
    }];
    
}

- (NSURL *) urlWithResouce:(NSString *)resource andParameters:(NSString *) parameters{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",self.uPushAuthServiceURI];
    urlString = [urlString stringByAppendingFormat:@"?_host=hqvsrv73&_svc=a/UPushAuth/%@&%@",resource,parameters];
    
    return [NSURL URLWithString:urlString];
}

@end
