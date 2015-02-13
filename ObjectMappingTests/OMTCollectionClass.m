//
//  OMTArrayClass.m
//  ObjectMapping
//
//  Created by Fabian Canas on 11/17/13.
//  Copyright (c) 2013-2014 Fabian Canas. All rights reserved.
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
//

#import <XCTest/XCTest.h>
#import "OHMKit.h"
#import "OMTBasicModel.h"

@interface OMTModelWithCollections : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *arrayOfBasicModels;
@property (nonatomic, copy) NSArray *arrayOfStrings;
@property (nonatomic, copy) NSDictionary *dictionaryOfBasicModels;
@end
@implementation OMTModelWithCollections
@end

@interface OMTCollectionClass : XCTestCase

@end

@implementation OMTCollectionClass

- (void)setUp
{
    [super setUp];
    OHMMappable([OMTModelWithCollections class]);
    OHMMappable([OMTBasicModel class]);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSetArrayClass
{
    XCTAssertNoThrow(OHMSetArrayClasses([OMTModelWithCollections class], @{NSStringFromSelector(@selector(arrayOfBasicModels)):[OMTBasicModel class]}), @"Should be able to set an array type dictionary on a mappable object");
    
    OMTBasicModel *basicModel;
    NSDictionary *basicModelDictionary1 = @{@"name": @"Fabian",
                                            @"favoriteWord": @"absurd",
                                            @"favoriteNumber" : @47};
    NSDictionary *basicModelDictionary2 = @{@"name": @"Music",
                                            @"favoriteWord": @"glitter",
                                            @"favoriteNumber" : @7};
    NSDictionary *arrayModelDictionary = @{@"name":@"arrayed",
                                           @"arrayOfBasicModels":@[basicModelDictionary1, basicModelDictionary2]};
    
    OMTModelWithCollections *arrayModel = [OMTModelWithCollections new];
    
    [arrayModel setValuesForKeysWithDictionary:arrayModelDictionary];
    
    basicModel = arrayModel.arrayOfBasicModels[0];
    
    OMTBasicModel *basicModel2;
    basicModel2 = arrayModel.arrayOfBasicModels[1];
    
    XCTAssertEqualObjects(basicModel.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEqualObjects(basicModel.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
    
    XCTAssertEqualObjects(basicModel2.name, @"Music", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEqualObjects(basicModel2.favoriteWord, @"glitter", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel2.favoriteNumber==7, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

- (void)testWrongArraySet
{
    NSDictionary *basicModelDictionary1 = @{@"name": @"Fabian",
                                            @"favoriteWord": @"absurd",
                                            @"favoriteNumber" : @47};
    NSDictionary *arrayModelDictionary = @{@"name":@"arrayed",
                                           @"arrayOfBasicModels":@[basicModelDictionary1],
                                           @"arrayOfStrings":@[@"hi", @"there"]};
    
    OMTModelWithCollections *arrayModel = [OMTModelWithCollections new];
    
    [arrayModel setValuesForKeysWithDictionary:arrayModelDictionary];
    
    XCTAssertEqualObjects(arrayModel.arrayOfStrings[0], @"hi", @"Arrays of non-mapped objects should be correctly set");
    XCTAssertEqualObjects(arrayModel.arrayOfStrings[1], @"there", @"Arrays of non-mapped objects should be correctly set");
}

- (void)testSetDictionaryClass
{
    XCTAssertNoThrow(OHMSetDictionaryClasses([OMTModelWithCollections class], @{NSStringFromSelector(@selector(dictionaryOfBasicModels)):[OMTBasicModel class]}), @"Should be able to set a dictionary type dictionary on a mappable object");
    
    NSDictionary *basicModelDictionary1 = @{@"name": @"Fabian",
                                            @"favoriteWord": @"absurd",
                                            @"favoriteNumber" : @47};
    NSDictionary *basicModelDictionary2 = @{@"name": @"Music",
                                            @"favoriteWord": @"glitter",
                                            @"favoriteNumber" : @7};
    NSDictionary *collectionModelDictionary = @{@"name":@"arrayed",
                                                @"dictionaryOfBasicModels":@{@"key1" : basicModelDictionary1, @"key2" : basicModelDictionary2}};
    
    OMTModelWithCollections *dictionaryModel = [OMTModelWithCollections new];
    
    [dictionaryModel setValuesForKeysWithDictionary:collectionModelDictionary];

    OMTBasicModel *basicModel1;
    OMTBasicModel *basicModel2;
    basicModel1 = dictionaryModel.dictionaryOfBasicModels[@"key1"];
    basicModel2 = dictionaryModel.dictionaryOfBasicModels[@"key2"];
    
    XCTAssertEqualObjects(basicModel1.name, @"Fabian", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEqualObjects(basicModel1.favoriteWord, @"absurd", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel1.favoriteNumber==47, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");

    XCTAssertEqualObjects(basicModel2.name, @"Music", @"OTMBasicModel should have its name set with a correct key w/o a mapping dictionary");
    XCTAssertEqualObjects(basicModel2.favoriteWord, @"glitter", @"OTMBasicModel should have its word set with a correct key w/o a mapping dictionary");
    XCTAssertTrue(basicModel2.favoriteNumber==7, @"OTMBasicModel should have its number set with a correct key w/o a mapping dictionary");
}

@end
