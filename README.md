# Shortcut for iOS

This SDK provides the following features:

- Collection of statistics (app usage, deep links).
- Support for [deferred deep linking](https://en.wikipedia.org/wiki/Deferred_deep_linking).
- Creation Shortcuts (short mobile deep links) to share from within your app.

There is also an [Android version of this SDK](https://github.com/shortcutmedia/shortcut-deeplink-sdk-android).

## Requirements

The SDK works with any device running iOS6 and newer.

## Installation

The SDK is packaged in a .framework file. To use it within your project follow these steps:

1. Download the latest SDK as zip file from the [releases page](https://github.com/shortcutmedia/shortcut-ios/releases).
2. Unzip it and add the *Shortcut.framework*  file to your project, e.g. by dragging it into the Project Navigator of your project in Xcode.
3. Within your project's **Build phases** make sure that the *Shortcut.framework* is added in the **Link binary with libraries** section. If you don't find it there, drag it from the Project Navigator to the list.

## Prerequisites

To make use of this SDK you need the following:

- An API key. Use the [Shortcut Manager](http://manager.shortcutmedia.com/mobile_apps) to create a mobile app with an associated API key.

For the deep linking features you need in addition:

- An iOS app that supports deep linking (using a [custom URL scheme](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html#//apple_ref/doc/uid/TP40007072-CH6-SW10) or [Universal Links](https://developer.apple.com/library/ios/documentation/General/Conceptual/AppSearch/UniversalLinks.html)).
- A Shortcut with a mobile deep link to your app. Use the [Shortcut Manager](http://manager.shortcutmedia.com) to create one.

## Integration into your app

#### General setup

Make sure to import our SDK in all files where you use it:

```objective-c
#import <Shortcut/Shortcut.h>
```

Use the [Shortcut Manager](http://manager.shortcutmedia.com/mobile_apps) to create a mobile app with an associated API key. Then launch the SDK with your API key's auth token by adding the following to `-application:didFinishLaunchingWithOptions:` in your *AppDelegate.m* file:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

[Shortcut launchWithAuthToken:@"YOUR_AUTH_TOKEN_HERE"];

// ...
return YES;
}
```

#### Collecting deep link interaction statistics

To collect deep link interaction statistics you have to tell the SDK when a deep link is opened: The SDK keeps track of your users looking at deep link content through sessions. You have to create a session whenever a a deep link is opened; the SDK will automatically terminate the session when a user leaves your app.

##### When using custom URL schemes:
Add the following to `-application:openURL:sourceApplication:annotation:` (you have added this method to your app delegate when you implemented your app's custom-scheme deep link handling):

```objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

SCSession *deepLinkSession = [Shortcut startDeepLinkSessionWithURL:url];
url = deepLinkSession.url // Use the session object's url property for further processing

// ...
}
```

##### When using Universal Links:
Add the following to `-application:continueUserActivity:restorationHandler:` (you have added this method to your app delegate when you implemented your app's Universal Link handling):

```objective-c
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {

if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
self.deepLinkSession = [Shortcut startDeepLinkSessionWithURL:userActivity.webpageURL];
userActivity.webpageURL = self.deepLinkSession.url; // Use the session object's url property for further processing
}

// ...
}
```

#### Creating Shortcuts (short mobile deep links)

Creating short links is an asynchronous process, since your link parameters need to be sent to the Shortcut backend. This can take a short amount of time during which you do not want to block your app. Therefore the short link creation process runs in the background and you are notified once it is finished via a completion handler.

**An example:** Let's assume you have a *Share* button in your app which should bring up an action sheet that allows you to share some content within your app through a short link.

An implementation could look something like this:

```objective-c
- (IBAction)shareButtonPressed:(id)button {

[Shortcut createShortLinkWithTitle:@"content title"
websiteURL:[NSURL URLWithString:@"http://your.site/content"]
deepLinkURL:[NSURL URLWithString:@"your-app://your/content"]
completionHandler:^(NSURL *shortLinkURL, NSError *error) {
if (!error) {
[self displayShareSheetWithURL:shortLinkURL];
} else {
// do error handling...
}
}];
}

- (void)displayShareSheetWithURL:(NSURL *)urlToShare {
// ...
}
```

This will create a short link that deep links into your app on all platforms you have configured in the Shortcut Manager.

**Advanced configuration:** If you have different deep link schemes for different platforms you can use the following method instead:

```objective-c
- (IBAction)shareButtonPressed:(id)button {

[Shortcut createShortLinkWithTitle:@"content title"
websiteURL:[NSURL URLWithString:@"http://your.site/content"]
iOSDeepLink:[NSURL URLWithString:@"your-ios-scheme://your/content"]
androidDeepLink:[NSURL URLWithString:@"your-android-scheme://your/content"]
windowsPhoneDeepLink:[NSURL URLWithString:@"your-windows-phone-scheme://your/content"]
completionHandler:^(NSURL *shortLinkURL, NSError *error) {
if (!error) {
[self displayShareSheetWithURL:shortLinkURL];
} else {
// do error handling...
}
}];
}

- (void)displayShareSheetWithURL:(NSURL *)urlToShare {
// ...
}
```

The parameters `websiteURL` and `completionHandler` are mandatory. All other parameters are optional (you can pass nil).


## License
This project is released under the MIT license. See included LICENSE.txt file for details.
