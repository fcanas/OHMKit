//
//  OHMDictionaryMapping.h
//  ObjectMapping
//
//  Created by Fabian Canas on 8/1/14.
//  Copyright (c) 2014 Fabian Canas. All rights reserved.
//

#ifndef OHMKit_OHMDictionaryMapping_h
#define OHMKit_OHMDictionaryMapping_h

/**
 Sets the passed dictionary as the dictionary mapping dictionary for the class.

 The keys should correspond to keys on the model object that is of type NSDictionary, such as @p @@"favoriteColors". The values are the class of objects conforming to OHMMappable that the dictionary should be populated with. When a mapping is performed, if a data source contains an NSDictionary of dicitonaries for the given key, a dictionary of target classes populated from those dictionaries will be set instead.

 @param class The class on which to set the mapping dictionary.
 @param mappingDictionary A dictionary source key of strings, and target values of OHMMappable classes.
 */
extern void OHMSetDictionaryClasses(Class class, NSDictionary *classDictionary);

/**
 Adds the key value pairs from the passed dictionary to the existing dictionary mapping dictionary.

 If there is no existing dictionary mapping dictionary, one is created. If a value for a passed-in key exists, it will be overwritten.

 The keys should correspond to keys on the model object that is of type NSDictionary, such as @p @@"favoriteColors". The values are the class of objects conforming to OHMMappable that the dictionary should be populated with. When a mapping is performed, if a data source contains an NSDictionary of dicitonaries for the given key, a dictionary of target classes populated from those dictionaries will be set instead.

 @param class The class on which to set the mapping dictionary.
 @param mappingDictionary A dictionary source key of strings, and target values of OHMMappable classes.
 */
extern void OHMAddDictionaryClasses(Class class, NSDictionary *classDictionary);

/**
 Remove the dictionary mapping class for each key in @p keyArray on the given class.

 @param class The class whose mappings should be removed.
 @param keyArray An array of keys to be removed from dictionary mapping.
 */
extern void OHMRemoveDictionary(Class class, NSArray *keyArray);

#endif
