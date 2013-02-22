//
//  pushauthTests.m
//  pushauthTests
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "pushauthTests.h"
#import "UDMutableAuthToken.h" 

@implementation pushauthTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testUDAuthTokenCreation{
    NSString *testValue = @"aaa";
    NSTimeInterval testLifetime = 100;
    UDTokenType testType = UDAccessTokenType;
    
    UDAuthToken *immutableToken = [[UDAuthToken alloc] initWithValue:testValue Lifetime:testLifetime Type:testType];
    
    STAssertTrue([immutableToken.value isEqualToString:testValue], @"Value property not match");
    STAssertTrue((immutableToken.lifetime == testLifetime), @"Lifetime property not match");
    STAssertTrue((immutableToken.type == testType), @"Type property not match");
}

- (void) testUDAuthTokenFactoryMethods{
    NSString *testValue = @"aaa";
    NSTimeInterval testLifetime = 100;
    
    UDAuthToken *accessToken = [UDAuthToken accessTokenWithWalue:testValue Lifetime:testLifetime];
    STAssertTrue([accessToken.value isEqualToString:testValue], @"Value property not match");
    STAssertTrue((accessToken.lifetime == testLifetime), @"Lifetime property not match");
    STAssertTrue((accessToken.type == UDAccessTokenType), @"Type property not match");
    
    UDAuthToken *refreshToren = [UDAuthToken refreshTokenWithWalue:testValue Lifetime:testLifetime];
    STAssertTrue([refreshToren.value isEqualToString:testValue], @"Value property not match");
    STAssertTrue((refreshToren.lifetime == testLifetime), @"Lifetime property not match");
    STAssertTrue((refreshToren.type == UDRefreshTokenType), @"Type property not match");
}

- (void) testUDAuthTokenMutability{
    UDAuthToken *immutableToken = [[UDAuthToken alloc] init];
    
    STAssertFalse([immutableToken respondsToSelector:@selector(setValue:)], @"Value property is mutable");
    STAssertFalse([immutableToken respondsToSelector:@selector(setLifetime:)], @"Lifetime property is mutable");
    STAssertFalse([immutableToken respondsToSelector:@selector(setType:)], @"Type property is mutable");
    
}

- (void) testUDAuthTokenCopy{
    NSString *testValue = @"aaa";
    NSTimeInterval testLifetime = 100;
    UDTokenType testType = UDAccessTokenType;
    
    UDAuthToken *immutableToken = [[UDAuthToken alloc] initWithValue:testValue Lifetime:testLifetime Type:testType];
    UDAuthToken *copyOfImmutableToken = [immutableToken copy];
    
    STAssertTrue([copyOfImmutableToken.value isEqualToString:testValue], @"Value property not match");
    STAssertTrue((copyOfImmutableToken.lifetime == testLifetime), @"Lifetime property not match");
    STAssertTrue((copyOfImmutableToken.type == testType), @"Type property not match");
}

- (void) testUDAuthTokenMutableCopy{
    NSString *testValue = @"aaa";
    NSTimeInterval testLifetime = 100;
    UDTokenType testType = UDAccessTokenType;
    
    UDAuthToken *immutableToken = [[UDAuthToken alloc] initWithValue:testValue Lifetime:testLifetime Type:testType];
    UDMutableAuthToken *copyOfImmutableToken = [immutableToken mutableCopy];
    
    //Values validation
    STAssertTrue([copyOfImmutableToken.value isEqualToString:testValue], @"Value property not match");
    STAssertTrue((copyOfImmutableToken.lifetime == testLifetime), @"Lifetime property not match");
    STAssertTrue((copyOfImmutableToken.type == testType), @"Type property not match");
    
    //Mutability validation
    STAssertTrue([copyOfImmutableToken respondsToSelector:@selector(setValue:)], @"Value property is mutable");
    STAssertTrue([copyOfImmutableToken respondsToSelector:@selector(setLifetime:)], @"Lifetime property is mutable");
    STAssertTrue([copyOfImmutableToken respondsToSelector:@selector(setType:)], @"Type property is mutable");
    
    //Changes validation
    NSString *newTestValue = @"bbb";
    NSTimeInterval newTestLifetime = 200;
    UDTokenType newTestType = UDRefreshTokenType;
    
    copyOfImmutableToken.value = newTestValue;
    copyOfImmutableToken.lifetime = newTestLifetime;
    copyOfImmutableToken.type = newTestType;
    
    STAssertTrue([copyOfImmutableToken.value isEqualToString:newTestValue], @"Value property not changed");
    STAssertTrue((copyOfImmutableToken.lifetime == newTestLifetime), @"Lifetime property not changed");
    STAssertTrue((copyOfImmutableToken.type == newTestType), @"Type property not changed");
    
}

- (void) testUDMutableAuthTokenCopy{
    UDMutableAuthToken *mutableToken = [[UDMutableAuthToken alloc] init];
    UDAuthToken *immutableToken = [mutableToken copy];
    
    STAssertFalse([immutableToken respondsToSelector:@selector(setValue:)], @"UDAuthToken value property is mutable");
    STAssertFalse([immutableToken respondsToSelector:@selector(setLifetime:)], @"UDAuthToken lifetime property is mutable");
    STAssertFalse([immutableToken respondsToSelector:@selector(setType:)], @"UDAuthToken type property is mutable");
}

- (void) testUDMutableAuthTokenChanges{
    UDMutableAuthToken *mutableToken = [[UDMutableAuthToken alloc] initWithValue:@"aaa" Lifetime:100 Type:UDAccessTokenType];
    NSString *testValue = @"bbb";
    NSTimeInterval testLifetime = 200;
    UDTokenType testType = UDRefreshTokenType;
    
    mutableToken.value = testValue;
    mutableToken.lifetime = testLifetime;
    mutableToken.type = testType;
    
    STAssertTrue([mutableToken.value isEqualToString:testValue], @"UDMutableAuthToken value property not changed");
    STAssertTrue((mutableToken.lifetime == testLifetime), @"UDMutableAuthToken lifetime property not changed");
    STAssertTrue((mutableToken.type == testType), @"UDMutableAuthToken type property not changed");
}

@end
