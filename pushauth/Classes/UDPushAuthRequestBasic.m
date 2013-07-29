//
//  UDPushAuthRequestBasic.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthRequestBasic.h"

@implementation UDPushAuthRequestBasic
@synthesize uPushAuthServiceURI = _uPushAuthServiceURI;
@synthesize appID = _appID;


- (NSString *)constantGetParameters{
    if (_constantGetParameters ==nil) {
        _constantGetParameters = @"";
    }
    
    return _constantGetParameters;
}
- (NSString *) deviceType{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"ipad";
    }else{
        return @"iphone";
    }
}

- (void) registerDeviceWithPushToken:(NSString *)pushToken andCompleteonHandler:(void (^)(NSString *, BOOL))completeonHandler {
    NSURLRequest *request = [self requestWithResource:@"register" Parameters:[NSString stringWithFormat:@"push_token=%@&device_type=%@",pushToken,self.deviceType]]; 
    NSLog(@"Register URL %@",request);
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"error %@",error);
            return;
        }
        
        NSError *parseError = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData: data
                                                                     options: NSJSONReadingMutableContainers
                                                                       error: &parseError];
        if (parseError) {
            NSLog(@"Error parsing JSON %@",parseError.description);
        }
        
        NSString *deviceID = [responseData objectForKey:@"device_id"];
        
        if (deviceID == nil) {
            NSLog(@"deviceID key error");
            return;
        }
        
        completeonHandler(deviceID,NO);
    }];
    
}
- (void) activateDevice:(NSString *) deviceID WithActivationCode:(NSString *) activationCode CompleteonHandler:(void ( ^ ) (BOOL activationStatus)) completeonHandler{
    NSURLRequest *request = [self requestWithResource:@"activate" Parameters:[NSString stringWithFormat:@"device_id=%@&activation_code=%@",deviceID,activationCode]];
    NSLog(@"Activate URL %@",request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"activate error %@",error);
            return;
        }
        
        NSError *parseError = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData: data
                                                                     options: NSJSONReadingMutableContainers
                                                                       error: &parseError];
        if (parseError) {
            NSLog(@"Error parsing JSON %@",parseError.description);
        }
        
        NSString *isActivated = [responseData objectForKey:@"activate"];
        
        if (isActivated == nil) {
            NSLog(@"activate key error");
            completeonHandler(NO);
            return;
        }
        else{
            return completeonHandler(YES);
        }
        
        if ([isActivated isEqualToString:@"yes"]) {
            completeonHandler(YES);
        }
        else{
            completeonHandler(NO);
        }
        
    }];
    
}

- (void) authenticateDevice:(NSString *) deviceID WithCompleteonHandler:(void ( ^ ) (NSString *authCode, NSString *codeIdentifier)) completeonHandler{
    NSURLRequest *request = [self requestWithResource:@"auth" Parameters:[NSString stringWithFormat:@"client_id=test&redirect_uri=upush://%@",deviceID]];
    NSLog(@"Auth URL %@ %@",request,deviceID);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"auth error %@",error);
            return;
        }
        
        NSError *parseError = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData: data
                                                                     options: NSJSONReadingMutableContainers
                                                                       error: &parseError];
        if (parseError) {
            NSLog(@"Error parsing JSON %@",parseError.description);
        }
        
        NSString *authCode = [responseData objectForKey:@"code"];
        NSNumber *authCodeID = [responseData objectForKey:@"id"];
        
        if (!authCode || !authCodeID) {
            NSLog(@"authCode key error");
            return;
        }
        
        completeonHandler(authCode,[authCodeID stringValue]);
    }];
}

- (NSURLRequest *) requestWithResource:(NSString *) resource Parameters:(NSString *) parameters{
    NSURL *url = [self.uPushAuthServiceURI URLByAppendingPathComponent:resource];
    parameters = [parameters stringByAppendingFormat:@"&%@",self.constantGetParameters];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *requestPOSTData = [NSData dataWithBytes: [parameters UTF8String] length: [parameters length]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestPOSTData];
    
    return request;
}

@end
