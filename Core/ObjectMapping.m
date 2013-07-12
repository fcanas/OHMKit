//
//  ObjectMapping.m
//  ObjectMapping
//
//  Created by Fabian Canas on 7/11/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//
#import "ObjectMapping.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

const int _kOMClassMappingDictionaryKey;

#pragma mark - Class Method Overrides

void _OMSetMappingDictionary_Class_IMP(id self, SEL _cmd, NSDictionary *dictionary)
{
    objc_setAssociatedObject(self, &_kOMClassMappingDictionaryKey, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Instance Method Overrides

void _OMSetValueForUndefinedKey_IMP(id self, SEL _cmd, id value, NSString *key)
{
    NSDictionary *mapping = objc_getAssociatedObject([self class], &_kOMClassMappingDictionaryKey);
    
    NSString *newKey = mapping[key];
    if (newKey != nil) {
        [self setValue:value forKey:newKey];
    }
}

#pragma mark - Public

void OMMakeMappable(Class c)
{
    // Get the meta class
    const char *class_name = class_getName(c);
    Class meta_class = objc_getMetaClass(class_name);
    
    // Override Class method to set mapping dictionary
    struct objc_method_description m = protocol_getMethodDescription(@protocol(OMMappable), @selector(_OMSetMappingDictionary:), YES, NO);
    
    BOOL protocol_successful = class_addProtocol(meta_class, @protocol(OMMappable));
    BOOL class_mapping_successful = class_addMethod(meta_class, @selector(_OMSetMappingDictionary:), (IMP)_OMSetMappingDictionary_Class_IMP, m.types);
    
    
    IMP previousImplementation = class_replaceMethod(c, @selector(setValue:forUndefinedKey:), (IMP)_OMSetValueForUndefinedKey_IMP, "@@");
}

void OMMakeMappableWithDictionary(Class c, NSDictionary *mappingDictionary)
{
    OMMakeMappable(c);
//    const char *class_name = class_getName(c);
//    Class meta_class = objc_getMetaClass(class_name);
    [(Class<OMMappable>)c _OMSetMappingDictionary:mappingDictionary];
}

