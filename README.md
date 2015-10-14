# Shortcut Deep Linking SDK for iOS

This SDK provides the following features:

- Support for [deferred deep linking](https://en.wikipedia.org/wiki/Deferred_deep_linking).
- Collection of additional statistics to build a user acquisition funnel and evaluate user activity.
- Create new short (deep) links to share content from within your app.

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
- For creating new short links: An API key with auth token. Use the [Shortcut Manager](http://manager.shortcutmedia.com/users/api_keys) to create one.


## Integration into your app

To use any features of the SDK you have to import it in each file in which you want to use it:

```objective-c
#import <ShortcutDeepLinkingSDK/ShortcutDeepLinkingSDK.h>
```

#### Enabling deferred deep linking

To enable deferred deep linking you just have to tell the SDK about the app launch.

Add the following to `-application:didFinishLaunchingWithOptions:` in your *AppDelegate.m* file:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[SCDeepLinking sharedInstance] launch];

    // ...
    return YES;
}
```

#### Collecting deep link interaction statistics

To collect deep link interaction statistics you have to tell the SDK when a deep link is opened: The SDK keeps track of your users looking at deep link content through sessions. You have to create a session whenever a a deep link is opened; the SDK will automatically terminate the session when a user leaves your app.

Add the following to `-application:openURL:sourceApplication:annotation:` (you have added this method to your app delegate when you implemented your app's normal deep link handling):

```objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    SCSession *deepLinkSession = [[SCDeepLinking sharedInstance] startSessionWithURL:url];
    url = deepLinkSession.url // Use the session object's url property for further processing

    // ...
    return YES;
}
```

#### Creating short (deep) links

**Prerequisite:** You need an API key with an authentication token. You can generate one in the [Shortcut Manager](manager.shortcutmedia.com/users/api_keys).

Tell the SDK about your token by adding the following to `-application:didFinishLaunchingWithOptions:` in your *AppDelegate.m* file:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[SCDeepLinking sharedInstance] setAuthToken:@"YOUR_AUTH_TOKEN_HERE"];

    // ...
    return YES;
}
```

Creating short links is an asynchronous process, since your link parameters need to be sent to the Shortcut backend. This can take a short amount of time during which you do not want to block your app. Therefore the short link creation process runs in the background and you are notified once it is finished via a completion handler.

**An example:** Let's assume you have a *Share* button in your app which should bring up an action sheet that allows you to share some content within your app through a short link.

An implementation could look something like this:


```objective-c
- (IBAction)shareButtonPressed:(id)button {

    SCDeepLinking *dl = [SCDeepLinking sharedInstance];
    
    [dl createShortLinkWithTitle:@"content title"
                      websiteURL:[NSURL URLWithString:@"http://your.site/content"]
                  iOSAppStoreURL:[NSURL URLWithString:@"https://itunes.apple.com/app/idYOURAPPID?mt=8"]
                  iOSDeepLinkURL:[NSURL URLWithString:@"your-ios-scheme://your/content"]
              androidAppStoreURL:[NSURL URLWithString:@"https://play.google.com/store/apps/details?id=YOURAPPID"]
              androidDeepLinkURL:[NSURL URLWithString:@"your-android-scheme://your/content"]
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

All parameters for the `-createShortLinkWithTitle:websiteURL:iOSAppStoreURL:iOSDeepLinkURL:androidAppStoreURL:androidDeepLinkURL:completionHandler:` method except for `websiteURL` and `completionHandler` are optional.

There are also shorter alternative methods if you want to create a short link without any deep links (`-createShortLinkWithWebsiteURL:completionHandler:`) or a short link with just iOS deep links (`-createShortLinkWithTitle:websiteURL:iOSAppStoreURL:iOSDeepLinkURL:completionHandler:`).


## License
This project is released under the MIT license. See included LICENSE.txt file for details.
