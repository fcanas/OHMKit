//
//  ObjectMapping.h
//  ObjectMapping
//
//  Created by Fabian Canas on 7/11/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol OMMappable
+ (void)_OMSetMappingDictionary:(NSDictionary *)dictionary;
@end

extern void OMMakeMappable(Class c);
void OMMakeMappableWithDictionary(Class c, NSDictionary *mappingDictionary);
