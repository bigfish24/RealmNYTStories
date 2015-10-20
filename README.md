# RealmNYTStories
Ready-to-go JSON parsing of New York Times Top Stories API into Realm models

Included are pre-built model files: `NYTStory` and `NYTStoryImage` that represent the associated data for each story returned from the Top Stories API.

#### DO THIS FIRST: Register For NYT Top Stories API Key
Go to [Times Developer Network](http://developer.nytimes.com/) and register, then enable the key for the Top Stores API.

#### Installation
`RealmNYTStories` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

**Objective-C**
```
pod 'RealmNYTStories'
```
**Swift**
```
pod 'RealmSwiftNYTStories'
```

#### How To Use
**Objective-C**
```objc
// Call somewhere in your code
// Performs async request, parses JSON, and adds objects to given Realm
[NYTStory loadLatestStoriesIntoRealm:[RLMRealm defaultRealm]
                          withAPIKey:@"INSERT_YOUR_API_KEY_HERE"];
```
**Swift**
```objc
// Call somewhere in your code
// Performs async request, parses JSON, and adds objects to given Realm
NYTStory.loadLatestStories(intoRealm: try! Realm(), withAPIKey: "INSERT_YOUR_API_KEY_HERE")
```
