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

Shortcut allows you to generate short links immediately, no (potentially slow) backend roundtrip is required. This works as follows:

1. The SDK generates a unique short link and returns it to you immediately
2. The generated short link as well as all its parameters (website URL, title, deep links) are sent to the Shortcut backend in the background

This way you get a link immediately that you can present in a share sheet or send out via email, no need to wait for a backend.

**Important: You must make sure that a network connection is available when calling this method!**

**An example:** Let's assume you have a *Share* button in your app which should bring up an action sheet that allows you to share some content within your app through a short link.

An implementation could look something like this:

```objective-c
- (IBAction)shareButtonPressed:(id)button {

    NSURL *shortLinkURL = [Shortcut createShortLinkWithTitle:@"content title"
                                                  websiteURL:[NSURL URLWithString:@"http://your.site/content"]
                                                    deepLink:[NSURL URLWithString:@"your-app://your/content"]];
    [self displayShareSheetWithURL:shortLinkURL];
}

- (void)displayShareSheetWithURL:(NSURL *)urlToShare {
    // ...
}
```

##### Alternative: Asynchronous creation
There is also an asynchronous way to create a new short link. It works as follows:

1. The SDK sends the parameters for the short link to the backend
2. The backend generates a new short link and returns it to the SDK
3. The SDK notifies you of the new short link via a completion handler

This way you have to wait for the backend to generate the short link, but if there are any errors (e.g. no network connection) then you can react to them.

The implementation of the example above would look like this with the asynchronous call:

 ```objective-c
 - (IBAction)shareButtonPressed:(id)button {

    [Shortcut createShortLinkWithTitle:@"content title"
                            websiteURL:[NSURL URLWithString:@"http://your.site/content"]
                              deepLink:[NSURL URLWithString:@"your-app://your/content"]
                     completionHandler:^(NSURL *shortLinkURL, NSError *error) {
                         if (!error) {
                             [self displayShareSheetWithURL:shortLinkURL];
                         } else {
                             // do error handling...
                         }}];
}

- (void)displayShareSheetWithURL:(NSURL *)urlToShare {
    // ...
}
```

##### Different deep links per platform
If your deep links are not identical for the different platforms your app supports (iOS, Android, Windows Phone) then you can specify them on a per-platform basis, just use `[Shortcut createShortLinkWithTitle:websiteURL:iOSDeepLink:AndroidDeepLink:WindowsPhoneDeepLink:]` / `[Shortcut createShortLinkWithTitle:websiteURL:iOSDeepLink:AndroidDeepLink:WindowsPhoneDeepLink:completionHandler:]` instead.

## Migrating from the Shortcut Deep Linking SDK

The [Shortcut Deep Linking SDK](https://github.com/shortcutmedia/shortcut-deeplink-sdk-ios) has been deprecated and its functionality has been included into this SDK/[Shortcut for iOS](https://github.com/shortcutmedia/shortcut-ios).

Please follow these steps to migrate your code to use this new SDK:

1. Remove the `ShortcutDeepLinkingSDK.framework` from your project in Xcode.
2. Follow the steps in the [Installation](#installation) and [Prerequisites](#prerequisites) sections to add the new framework to your app.
3. Replace all occurrences of `#import <ShortcutDeepLinkingSDK/ShortcutDeepLinkingSDK.h>` with `#import <Shortcut/Shortcut.h>`.
4. This SDK uses class methods on the `Shortcut` class for all its interactions instead of instance methods on the singleton instance of the `SCDeepLinking` class. So you have to replace all of the following calls to the SDK in your code:
  * `[[SCDeepLinking sharedInstance] launch]` with `[Shortcut launchWithAuthToken:]`
  * `[[SCDeepLinking sharedInstance] startSessionWithURL:]` with `[Shortcut startDeepLinkSessionWithURL:]`
  * `[[SCDeepLinking sharedInstance] createShortLinkWithTitle:websiteURL:deepLinkURL:completionHandler:]` with `[Shortcut createShortLinkWithTitle:websiteURL:deepLink:completionHandler:]`
5. Optional: Use the immediate short link generation from the new SDK if desired. Read through the [Creating Shortcuts](#creating-shortcuts-short-mobile-deep-links) section above and replace calls to `[Shortcut createShortLinkWithTitle:websiteURL:deepLink:completionHandler:]` with `[Shortcut createShortLinkWithTitle:websiteURL:deepLink:]`.

## License
This project is released under the MIT license. See included LICENSE.txt file for details.
