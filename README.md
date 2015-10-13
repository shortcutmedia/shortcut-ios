# Shortcut Deep Linking SDK for iOS

This SDK provides the following features:

- Support for [deferred deep linking](https://en.wikipedia.org/wiki/Deferred_deep_linking).
- Collection of additional statistics to build a user acquisition funnel and evaluate user activity.

There is also an [Android version of this SDK](https://github.com/shortcutmedia/shortcut-deeplink-sdk-android).

## Requirements

The SDK works with any device running iOS6 and newer.

## Installation

The SDK is packaged in a .framework file. To use it within your project follow these steps:

1. Download the latest SDK as zip file from the [releases page](https://github.com/shortcutmedia/shortcut-deeplink-sdk-ios/releases).
2. Unzip it and add the *ShortcutDeepLinkingSDK.framework*  file to your project, e.g. by dragging it into the Project Navigator of your project in Xcode.
3. Within your project's **Build phases** make sure that the *ShortcutDeepLinkingSDK.framework* is added in the **Link binary with libraries** section. If you don't find it there, drag it from the Project Navigator to the list.

## Prerequisites

To make use of this SDK you need the following:

- An iOS app that supports deep linking (responds to a [custom URL scheme](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html#//apple_ref/doc/uid/TP40007072-CH6-SW10)).
- A Shortcut Link with a deep link to your app specified. Use the [Shortcut Manager](http://manager.shortcutmedia.com) to create one.


## Integration into your app

#### Enabling deferred deep linking

**Step 1:** In your *AppDelegate.m* file you have to import the SDK:

```objective-c
#import <ShortcutDeepLinkingSDK/ShortcutDeepLinkingSDK.h>
```
**Step 2:** Then you have to tell the SDK about the app launch.

Add the following to `-application:didFinishLaunchingWithOptions:`:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

   [[SCDeepLinking sharedInstance] launch];

   // ...
  return YES;
}
```

#### Collecting deep link interaction statistics

**Step 1:** You have to tell the SDK when a deep link is opened.

Add the following to `-application:openURL:sourceApplication:annotation:` (you have added this method to your app delegate when you implemented your app's normal deep link handling):

```objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    SCSession *deepLinkSession = [[SCDeepLinking sharedInstance] startSessionWithURL:url];
    url = deepLinkSession.url // Use the session object's url property for further processing

    // ...
    return YES;
}
```


## License
This project is released under the MIT license. See included LICENSE.txt file for details.
