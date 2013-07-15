//
//  ObjectMappingTests.m
//  ObjectMappingTests
//
//  Created by Fabian Canas on 7/14/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "ObjectMapping.h"
#import "OMTBasicModel.h"

@interface ObjectMappingTests : XCTestCase

@end

@implementation ObjectMappingTests

- (void)setUp
{
    [super setUp];
    
    OMMakeMappable([OMTBasicModel class]);
    OMSetMapping([OMTBasicModel class], nil);
    OMSetAdapter([OMTBasicModel class], nil);
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Full Suite Test

- (void)testEverything
{
    OMSetMapping([OMTBasicModel class], @{@"favorite_word" : @"favoriteWord",
                                          @"favorite_number" : @"favoriteNumber",
                                          @"favorite_model" : @"favoriteModel",
                                          @"favorite_color" : @"favoriteColor"});
    OMValueAdapterBlock colorFromNumberArray = ^(NSArray *numberArray) {
        return [UIColor colorWithRed:[numberArray[0] integerValue]/255.0
                               green:[numberArray[1] integerValue]/255.0
                                blue:[numberArray[2] integerValue]/255.0
                               alpha:1];
    };
    OMSetAdapter([OMTBasicModel class], @{@"favoriteColor": colorFromNumberArray});
    
    OMTBasicModel *testModel = [[OMTBasicModel alloc] init];
    
    NSDictionary *innerModel = @{@"name": @"Music",
                                 @"favorite_word": @"glitter",
                                 @"favorite_number" : @7,
                                 @"favorite_color" : @[@194,@0,@242]};
    NSDictionary *outerModel = @{@"name": @"Fabian",
                                 @"favorite_word": @"absurd",
                                 @"favorite_number" : @47,
                                 @"favorite_model" : innerModel,
                                 @"favorite_color" : @[@48,@107,@91]};
    
    [testModel setValuesForKeysWithDictionary:outerModel];
    
    XCTAssertTrue([testModel.favoriteModel isKindOfClass:[OMTBasicModel class]], @"Recursive Mapping probably worked");
    XCTAssertTrue([testModel.favoriteColor isKindOfClass:[UIColor class]], @"Value Adapter for Color probably worked");
    XCTAssertTrue([testModel.favoriteModel.favoriteColor isKindOfClass:[UIColor class]], @"Value Adapter for Color in recursive mapping probably worked");
}

#pragma mark - Basic Class Manipulation & Hydration

- (void)testProtocolConformation
{
    XCTAssertTrue([OMTBasicModel conformsToProtocol:@protocol(OMMappable)], @"OMTBasicModel class has been made mappable, but doesn't conform to the mappable protocol.");
}

- (void)testDroppingUnknownKeys
{
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    NSDictionary *garbageDictionary = @{@"non_existent_key" : @"garbage value"};
    XCTAssertNoThrow([basicModel setValuesForKeysWithDictionary:garbageDictionary], @"OMTBasicModel should not crash if hydrated with garbage dictionary");
    
    XCTAssertNil(basicModel.name, @"OMTBasicModel should have all nil properties");
    XCTAssertNil(basicModel.favoriteWord, @"OMTBasicModel should have all nil properties");
}

- (void)testHydrationWithoutMappingDictionary
{
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favoriteWord": @"absurd",
                                                 @"favoriteNumber" : @47}];
    
    XCTAssertEquals(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEquals(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

#pragma mark - Mapping Dictionary

- (void)testHydrationWithGarbageMappingDictionry
{
    OMSetMapping([OMTBasicModel class], @{@"non_existent_key" : @"another_bad_key"});
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favoriteWord": @"absurd",
                                                 @"favoriteNumber" : @47}];
    
    XCTAssertEquals(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a relevant mapping");
    XCTAssertEquals(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a relevant mapping");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a relevant mapping");
}

- (void)testHydrationWithIdentityMappingDictionry
{
    OMSetMapping([OMTBasicModel class], @{@"name" : @"name",
                                          @"favoriteWord" : @"favoriteWord",
                                          @"favoriteNumber" : @"favoriteNumber"});
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favoriteWord": @"absurd",
                                                 @"favoriteNumber" : @47}];
    
    XCTAssertEquals(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEquals(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

- (void)testHydrationWithUsefulMappingDictionry
{
    OMSetMapping([OMTBasicModel class], @{@"favorite_word" : @"favoriteWord",
                                          @"favorite_number" : @"favoriteNumber"});
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favorite_word": @"absurd",
                                                 @"favorite_number" : @47}];
    
    XCTAssertEquals(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/ a mapping dictionary");
    XCTAssertEquals(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/ a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/ a mapping dictionary");
}

- (void)testRemovalOfMappingDictionary
{
    OMSetMapping([OMTBasicModel class], @{@"favorite_word" : @"favoriteWord",
                                          @"favorite_number" : @"favoriteNumber"});
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favorite_word": @"absurd",
                                                 @"favorite_number" : @47}];
    
    XCTAssertEquals(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/ a mapping dictionary");
    XCTAssertEquals(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/ a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/ a mapping dictionary");
    
    OMSetMapping([OMTBasicModel class], nil);
    
    basicModel = [[OMTBasicModel alloc] init];
    basicModel.favoriteNumber = 0;
    XCTAssertNil(basicModel.name, @"OMTBasicModel should have all nil properties");
    XCTAssertNil(basicModel.favoriteWord, @"OMTBasicModel should have all nil properties");
    
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favorite_word": @"absurd",
                                                 @"favorite_number" : @47}];
    
    XCTAssertEquals(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/ a mapping dictionary");
    XCTAssertNil(basicModel.favoriteWord, @"OTMBasicModel should have a nil word when mapping has been cleared");
    XCTAssertTrue(basicModel.favoriteNumber==0, @"OTMBasicModel should not have its number set w/o a correct mapping dictionary");
}

#pragma mark - Value Adapters

- (void)testBasicValueAdapter
{
    OMValueAdapterBlock fourtySevenAdapter = ^(NSString *string){
        if ([string isEqualToString:@"fourty-seven"]) {
            return @47;
        }
        return @0;
    };
    OMSetAdapter([OMTBasicModel class], @{@"favoriteNumber" : fourtySevenAdapter});

    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"favoriteNumber" : @"fourty-seven"}];

    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

@end
