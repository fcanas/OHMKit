//
//  OHMDictionaryMapping.h
//  ObjectMapping
//
//  Created by Fabian Canas on 8/1/14.
//  Copyright (c) 2014 Fabian Canas. All rights reserved.
//

#ifndef OHMKit_OHMDictionaryMapping_h
#define OHMKit_OHMDictionaryMapping_h

extern void OHMSetDictionaryClasses(Class c, NSDictionary *classDictionary);
extern void OHMAddDictionaryClasses(Class c, NSDictionary *classDictionary);
extern void OHMRemoveDictionary(Class c, NSArray *keyArray);

#endif
