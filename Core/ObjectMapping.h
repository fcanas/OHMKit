//
//  ObjectMapping.h
//  ObjectMapping
//
//  Created by Fabian Canas on 7/11/13.
//  Copyright (c) 2013-2014 Fabian Canas.
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

#import <Foundation/Foundation.h>

/**
 The OHMMappable protocol defines methods that can be used to set mapping patterns that OHMKit provides on classes.
 
 You do not need to implement any of these methods. By calling OHMMappable() with your class as a parameter, that receiving class will
 be modified to conform to OHMMappable.
 
 @warning Subclasses of classes that are dynamically made mappable do not themselves become mappable.
 */
@protocol OHMMappable

/**
 Sets the dictionary for mapping keys. 

 The key is a key you would like to map from, what might be called a source key such as @p @@"favorite_color". The values corresponds to the KVC key you would like to map it to, what might be called a target key such as @p @@"favoriteColor".

 @param dictionary A dictionary source key, target key pairs, all strings. The target key (or values in the dictionary) must be a KVC key the class can already respond to. OHMKit does not perform multiple key mappings.
 */
+ (void)ohm_setMapping:(NSDictionary *)dictionary;

/**
 Sets the dictionary of value adapters for keys. 

 The key is a KVC key for which you would like to adapt incoming values. NSNumbers do not need adapters to be mapped to primitive properties (e.g. int, NSInteger, float, BOOL). To adapt values to a property with a struct type, create an adapter block that creates the struct, and wrap it in an NSValue object and have the block return that NSValue.
 
 @param dictionary A dictionary target key, value adapter pairs. The target key (or keys in the dictionary) must be a KVC key the class can already respond to. The value must be a block of type OHMValueAdapterBlock, or conforming to the signature id(^)(id).
 */
+ (void)ohm_setAdapter:(NSDictionary *)dictionary;

/**
 Sets the dictionary of key to array class.
 
 The key is a KVC key corresponding to an NSAray or NSMutableArray for which you would like to fill with an array of objects of an OHMMappable class when given an array of dictionaries appropriate for hydrating that class.
 
 @param dictionary A dictionary target key, Class pairs. The target key (or keys in the dictionary) must be a KVC key the class can already respond to. The value must be a Class that has been made OHMMappable.
 */
+ (void)ohm_setArrayClasses:(NSDictionary *)dictionary;

/**
 Sets the dictionary of key to dictionary class.
 
 The key is a KVC key corresponding to an NSDictionary or NSMutableDictionary for which you would like to fill with a dictionary of objects of an OHMMappable class when given an NSDictionary of key value pairs where the values are dictionaries appropriate for hydrating that class.
 
 @param dictionary A dictionary target key, Class pairs. The target key (or keys in the dictionary) must be a KVC key the class can already respond to. The value must be a Class that has been made OHMMappable.
 */
+ (void)ohm_setDictionaryClasses:(NSDictionary *)dictionary;
@end

#pragma mark - Supporting Functions

/**
 Enable a class as mappable.
 */
extern void OHMMappable(Class c);

/**
 Sets the dictionary for mapping keys.
 
 The key is a key you would like to map from, what might be called a source key such as @p @@"favorite_color". The values corresponds to the KVC key you would like to map it to, what might be called a target key such as @p @@"favoriteColor".
 
 @param c The class on which to set the mapping dictionary.
 @param mappingDictionary A dictionary source key, target key pairs, all strings. The target key (or values in the dictionary) must be a KVC key the class can already respond to. OHMKit does not perform multiple key mappings.
 */
extern void OHMSetMapping(Class c, NSDictionary *mappingDictionary);

/**
 Adds the key value pairs from the passed dictionary to the existing mapping dictionary.

 If there is no existing mapping dictionary, one is created. If a value for a passed-in key exists, it will be overwritten.

 The key is a key you would like to map from, what might be called a source key such as @p @@"favorite_color". The values corresponds to the KVC key you would like to map it to, what might be called a target key such as @p @@"favoriteColor".
 
 @param c The class on which to set the mapping dictionary.
 @param mappingDictionary A dictionary source key, target key pairs, all strings. The target key (or values in the dictionary) must be a KVC key the class can already respond to. OHMKit does not perform multiple key mappings.
 */
extern void OHMAddMapping(Class c, NSDictionary *mappingDictionary);

/**
 Remove the mapping for each key in @p keyArray on the given class.

 @param c The class whose mappings should be removed.
 @param keyArray An array of keys to be removed from mapping.
 */
extern void OHMRemoveMapping(Class c, NSArray *keyArray);

#pragma mark - Helpers

#define ohm_key(x) NSStringFromSelector(@selector(x))


