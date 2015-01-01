# OHMKit

[![CI Status](http://img.shields.io/travis/fcanas/OHMKit.svg?style=flat)](https://travis-ci.org/fcanas/OHMKit)
[![Version](https://img.shields.io/cocoapods/v/OHMKit.svg?style=flat)](http://cocoadocs.org/docsets/OHMKit)
[![License](https://img.shields.io/cocoapods/l/OHMKit.svg?style=flat)](http://cocoadocs.org/docsets/OHMKit)
[![Platform](https://img.shields.io/cocoapods/p/OHMKit.svg?style=flat)](http://cocoadocs.org/docsets/OHMKit)

OHMKit makes it easy to hydrate Objective-C model objects from web services or local files. It works especially well with JSON. It's a lot like [Mantle](https://github.com/Mantle/Mantle) and [JSONModel](https://github.com/icanzilb/JSONModel) except that OHMKit doesn't require your models to inherit from a base class, making it more suitable for use with [Core Data](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/cdProgrammingGuide.html), [Parse](https://parse.com/), [Realm](http://realm.io/), or other libraries that _do_ require you to inherit from a base class.

OHMKit is a system for declaratively expressing how to translate data from JSON or plist to native Objective-C model objects. OHMKit does it without requiring your model to inherit from a base class, so it works with NSObjects, NSManagedObjects, or anything else that fits with your class hierarchy. And you can specify custom mappings anywhere you want, not just in the model. So you can keep the details of mapping a service to you models out of your model code and in your service code where it may be more appropriate.

Fit this JSON

```json
{
  "name": "Fabian",
  "favorite_word":  "absurd",
  "favorite_number": 47
}
```

into this object

```objc
@interface MYModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *favoriteWord;
@property (nonatomic, assign) NSInteger favoriteNumber;
@end
```

Map `user_name` from your web service to `userName` in your Objective-C models. Map a dictionary of numbers to a `UIColor`. Or hydrate a whole hierarchical JSON response, including arrays, dictionaries, and arbitrarily deep hierarchies of real Objective-C objects ... with a single line of code.

## Why?

OHMKit exists because [RestKit](https://github.com/RestKit/RestKit) (which is awesome by the way), is sometimes too big, heavy, and indirect. Because [Mantle](https://github.com/Mantle/Mantle) and [JSONModel](https://github.com/icanzilb/JSONModel) require your models to inherit from a base class.

Because sometimes, the web services your code consumes doesn't perfectly match your model objects.

OHMKit is under 200 lines of well-tested code being leveraged in the app store now in apps used by millions of users.

### What OHMKit is Not

OHMKit doesn't know about networks. Use [AFNetworking](https://github.com/AFNetworking/AFNetworking).

OHMKit doesn't know about routes. Use [SOCKit](https://github.com/jverkoey/sockit).

OHMKit doesn't know about JSON. Use [NSJSONSerialization](https://developer.apple.com/library/ios/documentation/foundation/reference/nsjsonserialization_class/Reference/Reference.html)

OHMKit doesn't know about CoreData. It will not manage graphs of entities for you quite like RestKit does. But OHMKit does not care about your model class' super class. So you can safely make subclasses of `NSManagedObject` mappable.

## Usage

### Basic Mapping

Given a model

```objc
@interface MYModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *favoriteWord;
@property (nonatomic, assign) NSInteger favoriteNumber;
@end
```

Anywhere in you application, make the model mappable, and assign it a dictionary of mappings from the keys a service will provide to the keys your actual model object uses. 

```objc
OHMMappable([MYModel class]);
OHMSetMapping([MYModel class], @{@"favorite_word"  : @"favoriteWord",
                                 @"favorite_number": @"favoriteNumber");
```
	
And now _anywhere_ in your application, objects of the class `MYModel` can be hydrated with a dictionary from a service whose keys will be translated by the mapping dictionary you provided.

```objc
MYModel *testModel = [[MYModel alloc] init];

[testModel setValuesForKeysWithDictionary:@{@"name"           : @"Fabian",
                                            @"favorite_word"  : @"absurd",
                                            @"favorite_number": @47];
```

### Recursive Mapping

Recursive mapping of mappable objects comes for free. If an object conforming to `<OMMappable>` has a property whose type also conforms to `<OMMappable>`, and the value for that key in the hydration dictionary is itself a dictionary, we'll instantiate a new model object and hydrate it. 

```objc
@interface MYClass : NSObject
@property (nonatomic, strong) NSString *name;
@end

@interface MYClass2 : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *favoriteWord;
@property (nonatomic, assign) NSInteger favoriteNumber;
@property (nonatomic, assign) MYClass *favoriteObject;
@end

OHMMappable([MYClass class]);

OHMMappable([MYClass2 class])
OHMSetMapping([MYClass2 class], @{@"favorite_word"  : @"favoriteWord", 
                                @"favorite_number": @"favoriteNumber", 
                                @"favorite_object" : @"favoriteObject"});

MYModel *testModel = [[MYClass2 alloc] init];
                             
NSDictionary *class2Response = @{@"name"           : @"Fabian", 
                                 @"favorite_word"  : @"absurd", 
                                 @"favorite_number": @2, 
                                 @"favorite_object": @{@"name" : @"Rock"}};

[testModel setValuesForKeysWithDictionary:class2Response];
```

Now, `testModel.favoriteObject` is an instance of `MYClass` hydrated with "Rock" as its name.

Internally, the new model object is initialized with `[[ alloc] init]`, and then hydrated with `[ setValuesForKeysWithDictionary:dictionary]`. If you have a model that needs special consideration for initialization, use an adapter block.

### Arrays

Arrays of dictionaries can be mapped to a class as well.

```objc
@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@end

@interface Roster : NSObject
@property (nonatomic, strong) NSArray *people;
@end

OHMMappable([Person class]);
OHMSetArrayClasses([Roster class], @{@"people":[Person class]});

NSDictionary *response = @{@[@{@"name":@"Bert"},
                             @{@"name":@"Ernie"},
                             @{@"name":@"Count"}];

Roster *roster = [Roster new];
[roster setValuesForKeysWithDictionary:response];
```

### Blocks serve as adapters to handle special properties

Users can pass a dictionary of blocks for field requiring special handling. Say a service sends back a dictionary that looks something like this:

```json
{
    "favorite_color": [
        122,
        50,
        80
    ],
    "least_favorite_color": [
        121,
        51,
        81
    ]
}
```

and we expect to map it to a model like this

```objc
@interface MYModel : NSObject
@property (nonatomic, strong) UIColor *favoriteColor;
@property (nonatomic, strong) UIColor *leastFavoriteColor;
@end
```

You can adapt the response with an adapter block:

```objc
OHMMappable([MYModel class]);
OHMSetMapping([MYModel class], @"least_favorite_color" : @"leastFavoriteColor", @"favorite_color" : @"favoriteColor")
OHMValueAdapterBlock colorFromNumberArray = ^(NSArray *numberArray) {
    return [UIColor colorWithRed:[numberArray[0] integerValue]/255.0
                           green:[numberArray[1] integerValue]/255.0
                            blue:[numberArray[2] integerValue]/255.0
                           alpha:1];
};
OHMSetAdapter([MYModel class], @{@"favoriteColor": colorFromNumberArray, @"leastFavoriteColor": colorFromNumberArray});
```

Note that the key for the adapter is the key on the model object, not on the response. And adapters are added for a property, not a type. If the above example had multiple properties that were colors, you would have to set an adapter block for each property. It would be smart to reuse adapter blocks in your code.

The `OHMValueAdapterBlock` type is a block that takes an `id` and returns an `id`. *i.e* `typedef id(^OHMValueAdapterBlock)(id);`


## Using it in a project

Use [CocoaPods](http://www.cocoapods.org), add OHMKit to your `PodFile`, and run `$ pod install`

```ruby
pod 'OHMKit'
```

## How?

OHMKit is a [mixin](http://en.wikipedia.org/wiki/Mixin) that makes it easy to keep any direct knowledge of the idiosyncrasies of the service you're consuming tucked away in a single place. 

It leverages the power of Key Value Coding ([KVC](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html)) that's built right in to Cocoa. It safely wraps `-setValue:forKey:` and `-setValue:forUndefinedKey:` to make calls to `setValuesForKeysWithDictionary:` extremely powerful.

## Contributing

Bug fixes, pull requests, enhancement requests and feedback are welcome. 

If you plan on contributing code, please notice that OHMKit has tests. If you're fixing a bug, please include a test that exposes the bug and therefore guards against a regression.

## TODO

### Undefined Keys

The behavior of undefined keys should be configurable at 3 levels:

1. Raise, because I should know about everything.
2. Drop unrecognized keys. We don't need them, but we shouldn't crash.
3. Add keys to a dictionary so that serialization/deserialization can be symmetric

Option 2 is currently the only behavior, and I'm inclined to leave is as the default behavior.

### NSCoding

It might be nice if we built a way to make a class `NSCoding` compatible if it's not already. I like [Mantle](https://github.com/github/Mantle), but I don't want to be told what my super class should be.

### NSValueTransformer

Adapter blocks versus `NSValueTransformer`s. There's no reason why both can't co-exist.

# License

```
Copyright (c) 2013-2014 Fabian Canas. All rights reserved.

This code is distributed under the terms and conditions of the MIT license.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

