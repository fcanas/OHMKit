# ObjectMapping

Map service responses to objects.

There is no networking layer. Use [AFNetworking](https://github.com/AFNetworking/AFNetworking).


## TODO
what to do about undefined keys?
Configured at 3 levels:

1. Raise, because I should know about everything.
2. Drop unrecognized keys. We don't need them, but we shouldn't crash.
3. Add keys to a dictionary so that serialization/deserialization can be symmetric