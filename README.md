# ObjectMapping

Map service responses to objects.

This project is a [mixin](http://en.wikipedia.org/wiki/Mixin) to make any Objective-C class easier to hydrate from a dictionary representation, such as you might get from a RESTful web service.

It exists because [RestKit](https://github.com/RestKit/RestKit) (which is awesome by the way), is too big, heavy, and indirect.

There is no networking layer. Use [AFNetworking](https://github.com/AFNetworking/AFNetworking).

## Example Usage

Given a model

	@interface OMTestModel : NSObject
	@property (nonatomic, strong) NSString *name;
	@property (nonatomic, strong) NSString *favoriteWord;
	@property (nonatomic, assign) NSInteger favoriteNumber;
	@end

Anywhere in you application, make the model mappable, and pass it a dictionary of mappings from the keys a service will provide to the keys your actual model object uses. 

	OMMakeMappableWithDictionary([OMTestModel class], @{@"favorite_word" : @"favoriteWord", @"favorite_number" : @"favoriteNumber"});
	
And now anywhere in your application, objects of the class `OMTestObject` can be hydrated with a dictionary form a service whose keys will be translated by the mapping dictionary you provided.

	OMTestModel *testModel = [[OMTestModel alloc] init];
    
    [testModel setValuesForKeysWithDictionary:@{@"name": @"Fabian", @"favorite_word": @"absurd", @"favorite_number" : @2}];
    NSLog(@"%@", testModel);

This makes it easy to keep any direct knowledge of the idiosyncrasies of the service you're consuming tucked away in a single place.


## TODO
what to do about undefined keys?
Configured at 3 levels:

1. Raise, because I should know about everything.
2. Drop unrecognized keys. We don't need them, but we shouldn't crash.
3. Add keys to a dictionary so that serialization/deserialization can be symmetric