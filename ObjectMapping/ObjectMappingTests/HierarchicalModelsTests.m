//
//  HierarchicalModelsTests.m
//  ObjectMapping
//
//  Created by Fabian Canas on 7/30/13.
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

@interface OMTHierarchyRootModel : NSObject
@property (nonatomic, strong) NSString *rootProperty;
@end
@interface OMTHierarchyChildModel : OMTHierarchyRootModel
@property (nonatomic, strong) NSString *childProperty;
@end
@interface OMTHierarchyUnmappedRootModel : NSObject
@property (nonatomic, strong) OMTHierarchyChildModel *mappedCrossModelProperty;
@property (nonatomic, strong) NSString *rootUnmappedProperty;
@end
@interface OMTHierarchyChildWithUnmappedRootModel : OMTHierarchyUnmappedRootModel
@property (nonatomic, strong) NSString *childMappedProperty;
@end
@implementation OMTHierarchyRootModel
@end
@implementation OMTHierarchyChildModel
@end
@implementation OMTHierarchyUnmappedRootModel
@end
@implementation OMTHierarchyChildWithUnmappedRootModel
@end



@interface HierarchicalModelsTests : XCTestCase
@property (nonatomic, copy) OHMValueAdapterBlock fourtySevenAdapter;
@end

@implementation HierarchicalModelsTests

- (void)setUp
{
    [super setUp];
    self.fourtySevenAdapter = ^(NSString *string){
        if ([string isEqualToString:@"fourty-seven"]) {
            return @"47";
        }
        if ([string isEqualToString:@"fourty-eight"]) {
            return @"48";
        }
        return @"0";
    };
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
    
    OHMSetAdapter([OMTHierarchyChildModel class], @{@"rootProperty": self.fourtySevenAdapter});
    
    [model setValue:@"fourty-seven" forKey:@"rootProperty"];
    
    XCTAssertEqualObjects(model.rootProperty, @"47", @"Adapter on a mapped root model");
}

- (void)testUnmappedRootHierarchy
{
    OHMMappable([OMTHierarchyChildWithUnmappedRootModel class]);
    OMTHierarchyChildWithUnmappedRootModel *model = [OMTHierarchyChildWithUnmappedRootModel new];
    [model setValuesForKeysWithDictionary:@{@"rootUnmappedProperty":@"r",@"childMappedProperty":@"c"}];
    XCTAssertEqualObjects(model.rootUnmappedProperty, @"r", @"An unmapped root hierarchy property should be mapped by a mappable child");
    XCTAssertEqualObjects(model.childMappedProperty, @"c", @"A mapped child hierarchy property should be mapped with an unmapped root");
    
    OHMSetAdapter([OMTHierarchyChildWithUnmappedRootModel class], @{@"rootUnmappedProperty": self.fourtySevenAdapter});
    
    [model setValuesForKeysWithDictionary:@{@"mappedCrossModelProperty": @{@"rootProperty":@"fourty-eight",@"childProperty":@"c"},
                                            @"rootUnmappedProperty":@"fourty-seven"}];
    
    XCTAssertEqualObjects(model.rootUnmappedProperty, @"47", @"Adapter on a mapped model on a property on an unmapped root");
    XCTAssertEqualObjects(model.mappedCrossModelProperty.rootProperty, @"48", @"");
    XCTAssertEqualObjects(model.mappedCrossModelProperty.childProperty, @"c", @"");
}

@end
