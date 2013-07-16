//
//  ObjectMapping.m
//  ObjectMapping
//
//  Created by Fabian Canas on 7/11/13.
//  Copyright (c) 2013 Fabian Canas.
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
#import "ObjectMapping.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

const int _kOMClassMappingDictionaryKey;
const int _kOMClassAdapterDictionaryKey;

#pragma mark - The Mixin

@implementation NSObject (OMMappingSwizzleBase)

- (void)OM_setValue:(id)value forKey:(NSString *)key
{
    // Adapter
    NSDictionary *adapters = objc_getAssociatedObject([self class], &_kOMClassAdapterDictionaryKey);
    OMValueAdapterBlock adapterForKey = adapters[key];
    BOOL adapterUsed = NO;
    if (adapterForKey) {
        value = adapterForKey(value);
        adapterUsed = YES;
    }
    
    if (!adapterUsed) {
        // Recursive Mapping
        objc_property_t p = class_getProperty([self class], [key UTF8String]);
        uint propertyCount = 0;
        objc_property_attribute_t *properties = property_copyAttributeList(p, &propertyCount);
        
        for (int propertyIndex = 0; propertyIndex<propertyCount; propertyIndex++) {
            objc_property_attribute_t property = properties[propertyIndex];
            if (property.name[0]=='T' && strlen(property.value)>3 && property.value[0] == '@') {
                const char *name = property.value;
                Class propertyClass = objc_getClass([[NSData dataWithBytes:(name + 2) length:strlen(name) - 3] bytes]);
                if (class_conformsToProtocol(propertyClass, @protocol(OMMappable))) {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        id p = [[propertyClass alloc] init];
                        [p setValuesForKeysWithDictionary:value];
                        [self OM_setValue:p forKey:key];
                        free(properties);
                        return;
                    }
                }
                break;
            }
        }
        free(properties);
    }
    
    // No recursive mapping needed. Proceed as usual
    [self OM_setValue:value forKey:key];
}

@end

#pragma mark - OMMappable methods

void _OMSetMappingDictionary_Class_IMP(id self, SEL _cmd, NSDictionary *dictionary)
{
    OMSetMapping(self, dictionary);
}

void _OMSetAdapterDictionary_Class_IMP(id self, SEL _cmd, NSDictionary *dictionary)
{
    OMSetAdapter(self, dictionary);
}

void _OMSetValueForUndefinedKey_IMP(id self, SEL _cmd, id value, NSString *key)
{
    NSDictionary *mapping = objc_getAssociatedObject([self class], &_kOMClassMappingDictionaryKey);
    
    NSString *newKey = mapping[key];
    if (newKey != nil) {
        [self setValue:value forKey:newKey];
    }
}

#pragma mark - Public Functions

void OMSetMapping(Class c, NSDictionary *mappingDictionary)
{
    objc_setAssociatedObject(c, &_kOMClassMappingDictionaryKey, mappingDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

void OMSetAdapter(Class c, NSDictionary *adapterDicionary)
{
    objc_setAssociatedObject(c, &_kOMClassAdapterDictionaryKey, adapterDicionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

void OMMakeMappable(Class c)
{
    // Get the meta class
    const char *class_name = class_getName(c);
    Class meta_class = objc_getMetaClass(class_name);
    
    // Override Class method to set mapping dictionary
    struct objc_method_description m = protocol_getMethodDescription(@protocol(OMMappable), @selector(_OMSetMappingDictionary:), YES, NO);
    struct objc_method_description a = protocol_getMethodDescription(@protocol(OMMappable), @selector(_OMSetAdapterDictionary:), YES, NO);
    
    class_addProtocol(c, @protocol(OMMappable));
    class_addMethod(meta_class, @selector(_OMSetMappingDictionary:), (IMP)_OMSetMappingDictionary_Class_IMP, m.types);
    class_addMethod(meta_class, @selector(_OMSetAdapterDictionary:), (IMP)_OMSetAdapterDictionary_Class_IMP, a.types);
    
    class_replaceMethod(c, @selector(setValue:forUndefinedKey:), (IMP)_OMSetValueForUndefinedKey_IMP, "@@");
    
    Method svfk = class_getInstanceMethod(c, @selector(setValue:forKey:));
    Method svfk_om = class_getInstanceMethod([NSObject class], @selector(OM_setValue:forKey:));
    method_exchangeImplementations(svfk, svfk_om);
}

void OMMakeMappableWithDictionary(Class c, NSDictionary *mappingDictionary)
{
    OMMakeMappable(c);
    OMSetMapping(c, mappingDictionary);
}

