//
//  HierarchicalModelsTests.m
//  ObjectMapping
//
//  Created by Fabian Canas on 7/30/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ObjectMapping.h"
#import "OMTHierarchyHierarchicalModel.h"

@interface HierarchicalModelsTests : XCTestCase

@end

@implementation HierarchicalModelsTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMappedRootHierarchy
{
    OHMMappable([OMTHierarchyRootModel class]);
    OHMMappable([OMTHierarchyChildModel class]);
    OMTHierarchyChildModel *model = [OMTHierarchyChildModel new];
    [model setValuesForKeysWithDictionary:@{@"rootProperty":@"r",@"childProperty":@"c"}];
    XCTAssertEqualObjects(model.rootProperty, @"r", @"A mapped root hierarchy property should be mapped by a mappable child");
    XCTAssertEqualObjects(model.childProperty, @"c", @"A mapped child hierarchy property should be mapped with a mappable root");
}

- (void)testUnmappedRootHierarchy
{
    OHMMappable([OMTHierarchyChildWithUnmappedRootModel class]);
    OMTHierarchyChildWithUnmappedRootModel *model = [OMTHierarchyChildWithUnmappedRootModel new];
    [model setValuesForKeysWithDictionary:@{@"rootUnmappedProperty":@"r",@"childMappedProperty":@"c"}];
    XCTAssertEqualObjects(model.rootUnmappedProperty, @"r", @"An unmapped root hierarchy property should be mapped by a mappable child");
    XCTAssertEqualObjects(model.childMappedProperty, @"c", @"A mapped child hierarchy property should be mapped with an unmapped root");
}

@end
