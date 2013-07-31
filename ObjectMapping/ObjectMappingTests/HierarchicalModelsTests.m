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
/*
    @interface OMTHierarchyRootModel : NSObject
    @property (nonatomic, strong) NSString *rootProperty;
    @end

    @interface OMTHierarchyChildModel : NSObject
    @property (nonatomic, strong) NSString *childProperty;
    @end

    @interface OMTHierarchyUnmappedRootModel : NSObject
    @property (nonatomic, strong) NSString *rootUnmappedProperty;
    @end

    @interface OMTHierarchyChildWithUnmappedRootModel : NSObject
    @property (nonatomic, strong) NSString *childMappedProperty;
    @end
 */

@interface HierarchicalModelsTests : XCTestCase

@end

@implementation HierarchicalModelsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMappedRootHierarchy
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    OHMMappable([OMTHierarchyRootModel class]);
}

@end
