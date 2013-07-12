//
//  FCAppDelegate.m
//  ObjectMapper
//
//  Created by Fabian Canas on 7/4/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import "FCAppDelegate.h"
#import "OMTestModel.h"

#import <ObjectMapping/ObjectMapping.h>

@implementation FCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    OMMakeMappableWithDictionary([OMTestModel class], @{@"favorite_word" : @"favoriteWord", @"favorite_number" : @"favoriteNumber"});
    
    OMTestModel *testModel = [[OMTestModel alloc] init];
    
    [testModel setValuesForKeysWithDictionary:@{@"name": @"Fabian", @"favorite_word": @"absurd", @"favorite_number" : @2}];
    NSLog(@"%@", testModel);
}

@end
