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
+ (void)_OMSetAdapterDictionary:(NSDictionary *)dictionary;
@end

typedef id(^OMValueAdapterBlock)(id);

extern void OMMakeMappable(Class c);
extern void OMSetMapping(Class c, NSDictionary *mappingDictionary);
extern void OMSetAdapter(Class c, NSDictionary *adapterDictionary);
void OMMakeMappableWithDictionary(Class c, NSDictionary *mappingDictionary);
