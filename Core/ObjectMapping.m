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
    objc_property_t p = class_getProperty([self class], [key UTF8String]);
    uint propertyCount = 0;
    objc_property_attribute_t *properties = property_copyAttributeList(p, &propertyCount);
    
    for (int propertyIndex = 0; propertyIndex<propertyCount; propertyIndex++) {
        objc_property_attribute_t property = properties[propertyIndex];
        if (property.name[0]=='T' && strlen(property.value)>4 && property.value[0] == '@') {
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
    
    [self OM_setValue:value forKey:key];
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}

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

#pragma mark - Public

void OMMakeMappable(Class c)
{
    // Get the meta class
    const char *class_name = class_getName(c);
    Class meta_class = objc_getMetaClass(class_name);
    
    // Override Class method to set mapping dictionary
    struct objc_method_description m = protocol_getMethodDescription(@protocol(OMMappable), @selector(_OMSetMappingDictionary:), YES, NO);
    
    BOOL protocol_successful = class_addProtocol(c, @protocol(OMMappable));
    BOOL class_mapping_successful = class_addMethod(meta_class, @selector(_OMSetMappingDictionary:), (IMP)_OMSetMappingDictionary_Class_IMP, m.types);
    
    IMP previousSVFUKImplementation = class_replaceMethod(c, @selector(setValue:forUndefinedKey:), (IMP)_OMSetValueForUndefinedKey_IMP, "@@");
    
    Method svfk = class_getInstanceMethod(c, @selector(setValue:forKey:));
    Method svfk_om = class_getInstanceMethod([NSObject class], @selector(OM_setValue:forKey:));
    method_exchangeImplementations(svfk, svfk_om);
}

void OMMakeMappableWithDictionary(Class c, NSDictionary *mappingDictionary)
{
    OMMakeMappable(c);
    [(Class<OMMappable>)c _OMSetMappingDictionary:mappingDictionary];
}

