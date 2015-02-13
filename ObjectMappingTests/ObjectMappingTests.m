//
//  ObjectMappingTests.m
//  ObjectMappingTests
//
//  Created by Fabian Canas on 7/14/13.
//  Copyright (c) 2013 Fabian Canas.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "OHMKit.h"
#import "OMTBasicModel.h"

@interface ObjectMappingTests : XCTestCase

@end

@implementation ObjectMappingTests

- (void)setUp
{
    [super setUp];
    OHMMappable([OMTBasicModel class]);
    OHMSetMapping([OMTBasicModel class], nil);
    OHMSetAdapter([OMTBasicModel class], nil);
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Helper Tests

- (void)testSelectorToStringHelper
{
    XCTAssertEqualObjects(@"favoriteWord", ohm_key(favoriteWord), @"ohm_key() should convert selectors to keys");
}

#pragma mark - Basic Class Manipulation & Hydration

- (void)testProtocolConformation
{
    XCTAssertTrue([OMTBasicModel conformsToProtocol:@protocol(OHMMappable)], @"OMTBasicModel class has been made mappable, but doesn't conform to the mappable protocol.");
}

- (void)testDroppingUnknownKeys
{
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    NSDictionary *garbageDictionary = @{@"non_existent_key" : @"garbage value"};
    XCTAssertNoThrow([basicModel setValuesForKeysWithDictionary:garbageDictionary], @"OMTBasicModel should not crash if hydrated with garbage dictionary");
    
    XCTAssertNil(basicModel.name, @"OMTBasicModel should have all nil properties");
    XCTAssertNil(basicModel.favoriteWord, @"OMTBasicModel should have all nil properties");
}

- (void)testThrowingExceptionsFromNonMappableObjects
{
    XCTAssertThrowsSpecificNamed([[NSObject new] setValue:@2 forKey:@"a key that NSObject Doesn't have"], NSException, NSUndefinedKeyException, @"Classes that haven't been declared mappable should throw undefined key exception");
}

- (void)testHydrationWithoutMappingDictionary
{
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favoriteWord": @"absurd",
                                                 @"favoriteNumber" : @47}];
    
    XCTAssertEqualObjects(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEqualObjects(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

#pragma mark - Protocol Conformance

- (void)testProtocolConformance
{
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    XCTAssertTrue([basicModel conformsToProtocol:@protocol(OHMMappable)], @"A basic model made mappable should conform to the mappable protocol");
}

#pragma mark - Mapping Dictionary

- (void)testHydrationWithGarbageMappingDictionry
{
    OHMSetMapping([OMTBasicModel class], @{@"non_existent_key" : @"another_bad_key"});
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favoriteWord": @"absurd",
                                                 @"favoriteNumber" : @47}];
    
    XCTAssertEqualObjects(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a relevant mapping");
    XCTAssertEqualObjects(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a relevant mapping");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a relevant mapping");
}

- (void)testHydrationWithIdentityMappingDictionry
{
    OHMSetMapping([OMTBasicModel class], @{@"name" : @"name",
                                           @"favoriteWord" : @"favoriteWord",
                                           @"favoriteNumber" : @"favoriteNumber"});
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favoriteWord": @"absurd",
                                                 @"favoriteNumber" : @47}];
    
    XCTAssertEqualObjects(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEqualObjects(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

- (void)testHydrationWithUsefulMappingDictionry
{
    OHMSetMapping([OMTBasicModel class], @{@"favorite_word" : @"favoriteWord",
                                           @"favorite_number" : @"favoriteNumber"});
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favorite_word": @"absurd",
                                                 @"favorite_number" : @47}];
    
    XCTAssertEqualObjects(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/ a mapping dictionary");
    XCTAssertEqualObjects(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/ a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/ a mapping dictionary");
}

- (void)testRemovalOfMappingDictionary
{
    OHMSetMapping([OMTBasicModel class], @{@"favorite_word" : @"favoriteWord",
                                           @"favorite_number" : @"favoriteNumber"});
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favorite_word": @"absurd",
                                                 @"favorite_number" : @47}];
    
    XCTAssertEqualObjects(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/ a mapping dictionary");
    XCTAssertEqualObjects(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/ a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/ a mapping dictionary");
    
    OHMSetMapping([OMTBasicModel class], nil);
    
    basicModel = [[OMTBasicModel alloc] init];
    basicModel.favoriteNumber = 0;
    XCTAssertNil(basicModel.name, @"OMTBasicModel should have all nil properties");
    XCTAssertNil(basicModel.favoriteWord, @"OMTBasicModel should have all nil properties");
    
    [basicModel setValuesForKeysWithDictionary:@{@"name": @"Fabian",
                                                 @"favorite_word": @"absurd",
                                                 @"favorite_number" : @47}];
    
    XCTAssertEqualObjects(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/ a mapping dictionary");
    XCTAssertNil(basicModel.favoriteWord, @"OTMBasicModel should have a nil word when mapping has been cleared");
    XCTAssertTrue(basicModel.favoriteNumber==0, @"OTMBasicModel should not have its number set w/o a correct mapping dictionary");
}

#pragma mark - Value Adapters

- (void)testBasicValueAdapter
{
    OHMValueAdapterBlock fourtySevenAdapter = ^(NSString *string){
        if ([string isEqualToString:@"fourty-seven"]) {
            return @47;
        }
        return @0;
    };
    OHMSetAdapter([OMTBasicModel class], @{@"favoriteNumber" : [fourtySevenAdapter copy]});
    
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"favoriteNumber" : @"fourty-seven"}];
    
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

- (void)testValueAdapterMethod
{
    OHMValueAdapterBlock fourtySevenAdapter = ^(NSString *string){
        if ([string isEqualToString:@"fourty-seven"]) {
            return @47;
        }
        return @0;
    };
    [((id<OHMMappable>)[OMTBasicModel class]) ohm_setAdapter:@{@"favoriteNumber" : fourtySevenAdapter}];
    
    OMTBasicModel *basicModel = [[OMTBasicModel alloc] init];
    [basicModel setValuesForKeysWithDictionary:@{@"favoriteNumber" : @"fourty-seven"}];
    
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

#pragma mark - Mutable Mapping

- (void)testAddingMapping
{
    OHMSetMapping([OMTBasicModel class], @{@"favorite_number" : @"favoriteNumber"});
    NSDictionary *modelData = @{@"name": @"Music",
                                @"favorite_word": @"glitter",
                                @"favorite_number" : @7,
                                };
    OMTBasicModel *basicModel = [OMTBasicModel new];
    [basicModel setValuesForKeysWithDictionary:modelData];
    XCTAssertEqualObjects(basicModel.name, @"Music", @"Model should be able to receive identity mappings");
    XCTAssertEqual(basicModel.favoriteNumber, 7, @"Model should be able to do basic mappings");
    XCTAssertNil(basicModel.favoriteWord, @"Model should not map unmapped keys");
    
    OHMAddMapping([OMTBasicModel class], @{@"favorite_word" : ohm_key(favoriteWord)});
    
    modelData = @{@"favorite_word": @"glitter",
                  @"favorite_number" : @47,
                  };
    
    [basicModel setValuesForKeysWithDictionary:modelData];
    XCTAssertEqualObjects(basicModel.favoriteWord, @"glitter", @"Model should map newly mapped keys");
    XCTAssertEqual(basicModel.favoriteNumber, 47, @"Model should be able to do basic mappings");
    XCTAssertEqualObjects(basicModel.name, @"Music", @"Model should not have values overwritten if they are not passed");
}

- (void)testRemoveMapping
{
    OHMSetMapping([OMTBasicModel class], @{@"favorite_number" : @"favoriteNumber",
                                           @"favorite_word" : @"favoriteWord"});
    
    NSDictionary *modelData = @{@"name": @"Music",
                                @"favorite_word": @"glitter",
                                @"favorite_number" : @7,
                                };
    OMTBasicModel *basicModel = [OMTBasicModel new];
    
    [basicModel setValuesForKeysWithDictionary:modelData];
    XCTAssertEqualObjects(basicModel.favoriteWord, @"glitter", @"Model should be able to do basic mappings");
    XCTAssertEqual(basicModel.favoriteNumber, 7, @"Model should be able to do basic mappings");
    XCTAssertEqualObjects(basicModel.name, @"Music", @"Model should be able to do basic mappings");
    
    OHMRemoveMapping([OMTBasicModel class], @[@"favorite_word"]);
    
    modelData = @{@"name":@"new name",
                  @"favorite_word": @"new word",
                  @"favorite_number" : @47,
                  };
    
    [basicModel setValuesForKeysWithDictionary:modelData];
    XCTAssertEqualObjects(basicModel.name, @"new name", @"Model should be able to receive identity mappings");
    XCTAssertEqual(basicModel.favoriteNumber, 47, @"Model should be able to do continue to do mapping after a removal");
    XCTAssertEqualObjects(basicModel.favoriteWord, @"glitter", @"model should not receive values into its unmapped property");
    
}

#pragma mark - All-Encompassing Test

- (void)testEverything
{
    OHMSetMapping([OMTBasicModel class], @{@"favorite_word" : @"favoriteWord",
                                           @"favorite_number" : @"favoriteNumber",
                                           @"favorite_model" : @"favoriteModel",
                                           @"favorite_color" : @"favoriteColor"});
    OHMValueAdapterBlock colorFromNumberArray = ^(NSArray *numberArray) {
        return [UIColor colorWithRed:[numberArray[0] integerValue]/255.0
                               green:[numberArray[1] integerValue]/255.0
                                blue:[numberArray[2] integerValue]/255.0
                               alpha:1];
    };
    OHMSetAdapter([OMTBasicModel class], @{@"favoriteColor": colorFromNumberArray});
    
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

@end
