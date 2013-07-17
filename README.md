# OHMKit

Impedance matching between services and model objects.

This project is a [mixin](http://en.wikipedia.org/wiki/Mixin) to make any Objective-C class easier to hydrate from a dictionary representation, such as you might get from a web service. It makes it easy to keep any direct knowledge of the idiosyncrasies of the service you're consuming tucked away in a single place.

It exists because [RestKit](https://github.com/RestKit/RestKit) (which is awesome by the way), is sometimes too big, heavy, and indirect.

This project doesn't know about networks. Use [AFNetworking](https://github.com/AFNetworking/AFNetworking).

This project doesn't know about routes. Use [SOCKit](https://github.com/jverkoey/sockit).

This project doesn't know about CoreData. It will not manage graphs of entities for you quite like RestKit does. But it *is* built on KVO, and does not care about your model objects' super class. So you can safely make subclasses of `NSManagedObject` mappable.

## Usage

### Basic Mapping

Given a model

```
@interface MYModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *favoriteWord;
@property (nonatomic, assign) NSInteger favoriteNumber;
@end
```

Anywhere in you application, make the model mappable, and assign it a dictionary of mappings from the keys a service will provide to the keys your actual model object uses. 

```
OHMMappable([MYModel class]);
OHMSetMapping([MYModel class], @{@"favorite_word"  : @"favoriteWord",
                                 @"favorite_number": @"favoriteNumber");
```
	
And now anywhere in your application, objects of the class `MYModel` can be hydrated with a dictionary from a service whose keys will be translated by the mapping dictionary you provided.

```
MYModel *testModel = [[MYModel alloc] init];

[testModel setValuesForKeysWithDictionary:@{@"name"           : @"Fabian",
                                            @"favorite_word"  : @"absurd",
                                            @"favorite_number": @47];
```

### Recursive Mapping

You don't have to do anything special to get recursive mapping of mappable objects. If an object conforming to `<OMMappable>` has a property whose type also conforms to `<OMMappable>`, and the value for that key in the hydration dictionary is itself a dictionary, we'll instantiate a new model object and hydrate it. (If that didn't make sense, just read the next code snippet)

```
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

### Adapter Blocks to handle special properties

Users can pass a dictionary of blocks for field requiring special handling. Say a service sends back a dictionary that looks something like this:

```
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

```
@interface MYModel : NSObject
@property (nonatomic, strong) UIColor *favoriteColor;
@property (nonatomic, strong) UIColor *leastFavoriteColor;
@end
```

You can adapt the response with an adapter block:

```	
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


## TODO

### Undefined Keys

The behavior of undefined keys should be configurable at 3 levels:

1. Raise, because I should know about everything.
2. Drop unrecognized keys. We don't need them, but we shouldn't crash.
3. Add keys to a dictionary so that serialization/deserialization can be symmetric

Option 2 is currently the only behavior, and I'm inclined to leave is as the default behavior.

