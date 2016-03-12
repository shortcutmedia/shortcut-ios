//
//  Shortcut.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 12/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSession.h"

@interface Shortcut : NSObject

/**
 *  Initializes the SDK and handles the application launch (deferred deep linking, event tracking).
 *
 *  This method should be called in the app delegate's application:didFinishLaunchingWithOptions:
 *  In addition to setting up the SDK it does the following:
 *  - Deferred deep link lookup: it checks for a stored deep link for the current device on the Shortcut
 *    backend and triggers an opening of the stored deep link if one was found.
 *  - Event tracking: it tracks the opening or install of the app in the Shortcut backend
 *
 *  @param authToken The token to use for authentication with the Shortcut backend. @see SCConfig
 */
+ (void)launchWithAuthToken:(NSString *)authToken;

/**
 *  Starts a deep link viewing session and returns it.
 *
 *  This method should be called whenever your app opens a deep link (e.g. in the app delegate's
 *  application:openURL:sourceApplication:annotation: for custom scheme deep links or in the app delegate's
 *  application:continueUserActivity:restorationHandler: for Universal Links).
 *  It creates and starts a deep link viewing session for the given deep link URL. A session spans the time the
 *  user is looking at a deep link and reports the duration to the Shortcut backend if the session was started
 *  by visiting a Shortcut link.
 *  The session's url property contains a URL stripped of all additional query parameters Shortcut needs to
 *  attribute the URL to the correct Shortcut link. So use this URL for further processing.
 *
 *  @param url The deep link URL that is/was opened.
 *
 *  @return A session describing the viewing of a deep link.
 */
+ (SCSession *)startDeepLinkSessionWithURL:(NSURL *)url;

/**
 *  Creates a new short (deep) link.
 *
 *  This method creates a new short link in the Shortcut backend with the given parameters. When the short link
 *  is created, the method will invoke the completion handler. The new short link's URL will be passed to the
 *  handler. If an error occurs, the handler also gets an error object describing the error.
 *  The handler is executed on the same queue on which the method was called: if you want to do UI stuff in
 *  the handler and called this method on a background queue then it is your responsibility to invoke the
 *  UI stuff on the main queue.
 *
 *  @param title The title of the new short link (optional).
 *  @param websiteURL The URL of the website the short link points to by default.
 *  @param deepLink The deep link URL the short link should link to on all platforms (optional).
 *  @param completionHandler A handler that will be called with the short link URL once the short link is created.
 */
+ (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                        deepLink:(NSURL *)deepLink
               completionHandler:(void (^)(NSURL *shortLinkURL, NSError *error))completionHandler;

/**
 *  Creates a new short (deep) link.
 *
 *  This method creates a new short link in the Shortcut backend with the given parameters. When the short link
 *  is created, the method will invoke the completion handler. The new short link's URL will be passed to the
 *  handler. If an error occurs, the handler also gets an error object describing the error.
 *  The handler is executed on the same queue on which the method was called: if you want to do UI stuff in
 *  the handler and called this method on a background queue then it is your responsibility to invoke the
 *  UI stuff on the main queue.
 *
 *  @param title The title of the new short link (optional).
 *  @param websiteURL The URL of the website the short link points to by default.
 *  @param iOSDeepLink The deep link URL the short link should link to on iOS (optional).
 *  @param androidDeepLink The deep link URL the short link should link to on Android (optional).
 *  @param windowsPhoneDeepLink The deep link URL the short link should link to on Windows Phone (optional).
 *  @param completionHandler A handler that will be called with the short link URL once the short link is created.
 */
+ (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                     iOSDeepLink:(NSURL *)iOSDeepLink
                 androidDeepLink:(NSURL *)androidDeepLink
            windowsPhoneDeepLink:(NSURL *)windowsPhoneDeepLink
               completionHandler:(void (^)(NSURL *shortLinkURL, NSError *error))completionHandler;

@end
