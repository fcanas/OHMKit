# ObjectMapping

Map service responses to objects.

This project is a [mixin](http://en.wikipedia.org/wiki/Mixin) to make any Objective-C class easier to hydrate from a dictionary representation, such as you might get from a RESTful web service.

It exists because [RestKit](https://github.com/RestKit/RestKit) (which is awesome by the way), is sometimes too big, heavy, and indirect.

There is no networking layer. Use [AFNetworking](https://github.com/AFNetworking/AFNetworking).

## Usage

### Basic Mapping

Given a model

	@interface OMTestModel : NSObject
	@property (nonatomic, strong) NSString *name;
	@property (nonatomic, strong) NSString *favoriteWord;
	@property (nonatomic, assign) NSInteger favoriteNumber;
	@end

Anywhere in you application, make the model mappable, and pass it a dictionary of mappings from the keys a service will provide to the keys your actual model object uses. 

	OMMakeMappableWithDictionary([OMTestModel class], @{@"favorite_word" : @"favoriteWord", @"favorite_number" : @"favoriteNumber"});
	// This can also be done in separate steps, and the mapping dictionary can be reset at any time:
	// OMMakeMappable([OMTestModel class]);
	// [(id)[OMTestModel class] _OMSetMappingDictionary:@{@"favorite_word" : @"favoriteWord", @"favorite_number" : @"favoriteNumber", @"favorite_model" : @"favoriteModel"}];
	
And now anywhere in your application, objects of the class `OMTestObject` can be hydrated with a dictionary from a service whose keys will be translated by the mapping dictionary you provided.

	OMTestModel *testModel = [[OMTestModel alloc] init];
    
    [testModel setValuesForKeysWithDictionary:@{@"name": @"Fabian", @"favorite_word": @"absurd", @"favorite_number" : @2}];
    NSLog(@"%@", testModel);

This makes it easy to keep any direct knowledge of the idiosyncrasies of the service you're consuming tucked away in a single place.

### Recursive Mapping

You don't have to do anything special to get recursive mapping of `OMMappable` objects. If an object conforming to `<OMMappable>` has a property whose type also conforms to `<OMMappable>`, and the value for that key in the hydration dictionary is itself a dicitonary, we'll instantiate a new model object and hydrate it.

    OMMakeMappableWithDictionary([OMTestModel class], @{@"favorite_word" : @"favoriteWord", @"favorite_number" : @"favoriteNumber", @"favorite_model" : @"favoriteModel"});
    
    OMTestModel *testModel = [[OMTestModel alloc] init];
    
    NSDictionary *innerModel = @{@"name": @"Music", @"favorite_word": @"glitter", @"favorite_number" : @7};
    NSDictionary *outerModel = @{@"name": @"Fabian", @"favorite_word": @"absurd", @"favorite_number" : @2, @"favorite_model" : innerModel};
    
    [testModel setValuesForKeysWithDictionary:outerModel];
    // testModel.favoriteModel is an instance of OMTestModel 
    // hydrated with the innerModel dictionary.

## TODO
### Blocks to handle special types

Users should be able to pass a dictionary of blocks when a particular field requires special handling. Say a service sends back a dicitonary that looks something like this:

	{
	    "color": [
	        122,
	        50,
	        80
	    ]
	}

and we expect to map it to a model like this


	@interface MYColorModel : NSObject
	@property (nonatomic, strong) UIColor *color;
	@end

I'd like the developer to be able to specify how to adapt the response

    id(^colorFromNumberArray)(id) = ^(NSArray *numberArray) {
        return [UIColor colorWithRed:[numberArray[0] integerValue]/255.0
                               green:[numberArray[0] integerValue]/255.0
                                blue:[numberArray[0] integerValue]/255.0
                               alpha:1];
    };
    OMAddAdapters([MYColorModel class], @{@"color": colorFromNumberArray});


### Undefined Keys

The behavior of undefined keys should be configurable at 3 levels:

1. Raise, because I should know about everything.
2. Drop unrecognized keys. We don't need them, but we shouldn't crash.
3. Add keys to a dictionary so that serialization/deserialization can be symmetric

Option 2 is currently the only behavior, and I'm inclined to leave is as the default behavior.

