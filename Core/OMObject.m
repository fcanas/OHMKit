//
//  OMObject.m
//  ObjectMapping
//
//  Created by Fabian Canas on 7/4/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import "OMObject.h"
#import <objc/runtime.h>

@implementation OMObject

// This should be turned into a proxy object that's injected by a mapping system (maybe via category)
// so that the model doesn't need to be aware that it's being mapped.
// On load of the category, or this class, or something, it should swizzle the implementation
// of `setValue:forUndefinedKey:` to use this mapping system.

static NSMutableDictionary *mappingForClass;

+ (void)load
{
  mappingForClass = [NSMutableDictionary new];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  [self setValuesForKeysWithDictionary:dictionary];
  
  return self;
}

- (id)valueForUndefinedKey:(NSString *)key
{
  NSDictionary *mapping = mappingForClass[[self class]];
  NSString *newKey = mapping[key];
  if (newKey != nil) {
    return [self valueForKey:newKey];
  }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//  objc_property_t property = class_getProperty([self class], [key UTF8String]);
//  const char * propertyAttrs = property_getAttributes(property);
  
  
  
  NSDictionary *mapping = mappingForClass[[self class]];
  NSString *newKey = mapping[key];
  if (newKey != nil)
  {
    [self setValue:value forKey:newKey];
    return;
  }
}

@end