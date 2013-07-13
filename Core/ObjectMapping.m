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

#pragma mark - The Mixin

@implementation NSObject (OMMappingSwizzleBase)

- (void)OM_setValue:(id)value forKey:(NSString *)key
{
    [self OM_setValue:value forKey:key];
}

@end

@protocol OMMappablePrivate <OMMappable>

- (void)OM_Original_setValue:(id)value forKey:(NSString *)key;

@end

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

void _OMSetValueForKey_IMP(id self, SEL _cmd, id value, NSString *key)
{
    objc_property_t theProperty = class_getProperty([self class], [key UTF8String]);
    
    const char * propertyAttrs = property_getAttributes(theProperty);
    
    [(id<OMMappablePrivate>)self OM_Original_setValue:value forKey:key];
}

#pragma mark - Public

void OMMakeMappable(Class c)
{
    // Get the meta class
    const char *class_name = class_getName(c);
    Class meta_class = objc_getMetaClass(class_name);
    
    // Override Class method to set mapping dictionary
    struct objc_method_description m = protocol_getMethodDescription(@protocol(OMMappablePrivate), @selector(_OMSetMappingDictionary:), YES, NO);
    
    BOOL protocol_successful = class_addProtocol(meta_class, @protocol(OMMappablePrivate));
    BOOL class_mapping_successful = class_addMethod(meta_class, @selector(_OMSetMappingDictionary:), (IMP)_OMSetMappingDictionary_Class_IMP, m.types);
    
    IMP previousSVFUKImplementation = class_replaceMethod(c, @selector(setValue:forUndefinedKey:), (IMP)_OMSetValueForUndefinedKey_IMP, "@@");
    
    Method svfk = class_getInstanceMethod(c, @selector(setValue:forKey:));
    Method svfk_om = class_getInstanceMethod([NSObject class], @selector(setValue:forKey:));
    method_exchangeImplementations(<#Method m1#>, <#Method m2#>)
}

void OMMakeMappableWithDictionary(Class c, NSDictionary *mappingDictionary)
{
    OMMakeMappable(c);
    [(Class<OMMappable>)c _OMSetMappingDictionary:mappingDictionary];
}

