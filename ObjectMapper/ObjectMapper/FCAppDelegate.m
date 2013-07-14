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
    OMMakeMappableWithDictionary([OMTestModel class], @{@"favorite_word" : @"favoriteWord",
                                                        @"favorite_number" : @"favoriteNumber",
                                                        @"favorite_model" : @"favoriteModel",
                                                        @"favorite_color" : @"favoriteColor"});
    
    OMValueAdapterBlock colorFromNumberArray = ^(NSArray *numberArray) {
        return [NSColor colorWithRed:[numberArray[0] integerValue]/255.0
                               green:[numberArray[1] integerValue]/255.0
                                blue:[numberArray[2] integerValue]/255.0
                               alpha:1];
    };
    OMSetAdapter([OMTestModel class], @{@"favoriteColor": colorFromNumberArray});
    
    OMTestModel *testModel = [[OMTestModel alloc] init];
    
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
    NSLog(@"%@", testModel);
}

@end
