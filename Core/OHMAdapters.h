//
//  OHMAdapters.h
//  OHMKit
//
//  Created by Fabian Canas on 8/1/14.
//  Copyright (c) 2014 Fabian Canas. All rights reserved.
//

#ifndef OHMKit_OHMAdapters_h
#define OHMKit_OHMAdapters_h

/**
 A convenience block type that takes a single @p id and returns a single @p id.

 Adapters don't need to explicitly be of type OHMValueAdapterBlock. They can be
 any block with an equivalent signature.
 */
typedef __nullable id(^OHMValueAdapterBlock)(__nullable id);

/**
 Sets the dictionary of value adapters for keys.

 The key is a KVC key for which you would like to adapt incoming values.
 @p NSNumbers do not need adapters to be mapped to primitive properties (e.g.
 int, NSInteger, float, BOOL). To adapt values to a property with a struct type,
 create an adapter block that creates the struct, and wrap it in an NSValue
 object and have the block return that NSValue.

 @param c The class on which to set the adapter dictionary.
 @param adapterDictionary A dictionary target key, value adapter pairs. The
 target key (or keys in the dictionary) must be a KVC key the class can already
 respond to. The value must be a block of type @p OHMValueAdapterBlock, or
 conforming to the signature @p id(^)(id).
 */
extern void OHMSetAdapter(__nonnull Class c, NSDictionary<NSString *, OHMValueAdapterBlock> * __nullable adapterDictionary);

/**
 Sets the dictionary of reverse value adapters for keys.
 
 The key is a KVC key for which you would like to adapt outgoing values.
 @p NSNumbers do not need adapters to be mapped to primitive properties (e.g.
 int, NSInteger, float, BOOL). To adapt values to a property with a struct type,
 create an adapter block that creates the struct, and wrap it in an NSValue
 object and have the block return that NSValue.
 
 @param c The class on which to set the adapter dictionary.
 @param adapterDictionary A dictionary target key, value adapter pairs. The
 target key (or keys in the dictionary) must be a KVC key the class can already
 respond to. The value must be a block of type @p OHMValueAdapterBlock, or
 conforming to the signature @p id(^)(id).
 */
extern void OHMSetReverseAdapter(__nonnull Class c, NSDictionary<NSString *, OHMValueAdapterBlock> * __nullable adapterDictionary);

/**
 Adds the key value pairs from the passed dictionary to the existing adapter
 dictionary.

 The key is a KVC key for which you would like to adapt incoming values.
 @p NSNumbers do not need adapters to be mapped to primitive properties (e.g.
 int, NSInteger, float, BOOL). To adapt values to a property with a struct type,
 create an adapter block that creates the struct, and wrap it in an NSValue
 object and have the block return that NSValue.

 @param c The class on which to set the adapter dictionary.
 @param adapterDictionary A dictionary target key, value adapter pairs. The
 target key (or keys in the dictionary) must be a KVC key the class can already
 respond to. The value must be a block of type @p OHMValueAdapterBlock, or
 conforming to the signature @p id(^)(id).
 */
extern void OHMAddAdapter(__nonnull Class c, NSDictionary<NSString *, OHMValueAdapterBlock> * __nullable adapterDictionary);

/**
 Adds the key value pairs from the passed dictionary to the existing reverse
 adapter dictionary.
 
 The key is a KVC key for which you would like to adapt outgoing values.
 @p NSNumbers do not need adapters to be mapped to primitive properties (e.g.
 int, NSInteger, float, BOOL). To adapt values to a property with a struct type,
 create an adapter block that creates the struct, and wrap it in an NSValue
 object and have the block return that NSValue.
 
 @param c The class on which to set the adapter dictionary.
 @param adapterDictionary A dictionary target key, value adapter pairs. The
 target key (or keys in the dictionary) must be a KVC key the class can already
 respond to. The value must be a block of type @p OHMValueAdapterBlock, or
 conforming to the signature @p id(^)(id).
 */
extern void OHMAddReverseAdapter(__nonnull Class c, NSDictionary * __nullable adapterDictionary);

/**
 Remove the value adapters for each key in @p keyArray on the given class.

 @param c The class whose adapters should be removed.
 @param keyArray An array of keys to for which adapters should be removed.
 */
extern void OHMRemoveAdapter(__nonnull Class c, NSArray * __nullable keyArray);

/**
 Remove the reverse value adapters for each key in @p keyArray on the given class.
 
 @param c The class whose adapters should be removed.
 @param keyArray An array of keys to for which adapters should be removed.
 */
extern void OHMRemoveReverseAdapter(__nonnull Class c, NSArray * __nullable keyArray);

#endif
