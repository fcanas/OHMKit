//
//  OMTestModel.m
//  ObjectMapper
//
//  Created by Fabian Canas on 7/12/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import "OMTestModel.h"

@implementation OMTestModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"OMTestModel (0x%x) name: %@, favorite word: %@, favoriteNumber: %ld", ((int)self), self.name, self.favoriteWord, self.favoriteNumber];
}

@end
