//
//  OMTArrayClass.m
//  ObjectMapping
//
//  Created by Fabian Canas on 11/17/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ObjectMapping.h"
#import "OMTBasicModel.h"

@interface OMTModelWithArray : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *arrayOfBasicModels;
@property (nonatomic, copy) NSArray *arrayOfStrings;
@end
@implementation OMTModelWithArray
@end

@interface OMTArrayClass : XCTestCase

@end

@implementation OMTArrayClass

- (void)setUp
{
    [super setUp];
    OHMMappable([OMTModelWithArray class]);
    OHMMappable([OMTBasicModel class]);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSetArrayClass
{
    XCTAssertNoThrow(OHMSetArrayClasses([OMTModelWithArray class], @{NSStringFromSelector(@selector(arrayOfBasicModels)):[OMTBasicModel class]}), @"Should be able to set a type dictionary on a mappable object");
    
    OMTBasicModel *basicModel;
    NSDictionary *basicModelDictionary1 = @{@"name": @"Fabian",
                                            @"favoriteWord": @"absurd",
                                            @"favoriteNumber" : @47};
    NSDictionary *basicModelDictionary2 = @{@"name": @"Music",
                                            @"favoriteWord": @"glitter",
                                            @"favoriteNumber" : @7};
    NSDictionary *arrayModelDictionary = @{@"name":@"arrayed",
                                           @"arrayOfBasicModels":@[basicModelDictionary1, basicModelDictionary2]};
    
    OMTModelWithArray *arrayModel = [OMTModelWithArray new];
    
    [arrayModel setValuesForKeysWithDictionary:arrayModelDictionary];
    
    basicModel = arrayModel.arrayOfBasicModels[0];
    
    XCTAssertEqualObjects(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEqualObjects(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

- (void)testWrongArraySet
{
    NSDictionary *basicModelDictionary1 = @{@"name": @"Fabian",
                                            @"favoriteWord": @"absurd",
                                            @"favoriteNumber" : @47};
    NSDictionary *arrayModelDictionary = @{@"name":@"arrayed",
                                           @"arrayOfBasicModels":@[basicModelDictionary1],
                                           @"arrayOfStrings":@[@"hi", @"there"]};
    
    OMTModelWithArray *arrayModel = [OMTModelWithArray new];
    
    [arrayModel setValuesForKeysWithDictionary:arrayModelDictionary];
    
    XCTAssertEqualObjects(arrayModel.arrayOfStrings[0], @"hi", @"Arrays of non-mapped objects should be correctly set");
    XCTAssertEqualObjects(arrayModel.arrayOfStrings[1], @"there", @"Arrays of non-mapped objects should be correctly set");
}

@end
