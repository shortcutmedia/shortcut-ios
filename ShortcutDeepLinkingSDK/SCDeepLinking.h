//
//  ShortcutDeepLinkingSDK.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSession.h"

/**
 *  The SCDeepLinking class acts as central interaction point with the ShortcutDeepLinkingSDK.
 *
 *  @discussion
 *  It is implemented as a singleton: Use the SCDeepLinking +sharedInstance method to get the
 *  singleton instance.
 */
@interface SCDeepLinking : NSObject


/// @name Accessing the global instance

/**
 *  This class is a singleton. You cannot instantiate new instances.
 *  Use the SCDeepLinking +sharedInstance method to get the singleton instance.
 */
- (instancetype)init __attribute__((unavailable("use SCDeepLinking +sharedInstance")));

/**
 *  Returns the singleton instance.
 *
 *  @return The global instance.
 */
+ (instancetype)sharedInstance;


/// @name Interactions

/**
 *  Takes care of handling potential deferred deep links.
 *
 *  This method should be called in the app delegate's application:didFinishLaunchingWithOptions:
 *  It checks for a stored deep link for the current device on the Shortcut backend and triggers an opening
 *  of the stored deep link if one was found.
 */
- (void)launch;

/**
 *  Takes care of handling potential deferred deep links.
 *
 *  This method should be called in the app delegate's application:didFinishLaunchingWithOptions:
 *  It checks for a stored deep link for the current device on the Shortcut backend and triggers an opening
 *  of the stored deep link if one was found.
 *
 *  @param authToken The token to use for authentication with the Shortcut backend. @see SCConfig
 */
- (void)launchWithAuthToken:(NSString *)authToken;

/**
 *  Takes care of handling potential deferred deep links.
 *
 *  This method should be called in the app delegate's application:didFinishLaunchingWithOptions:
 *  It checks for a stored deep link for the current device on the Shortcut backend and triggers an opening
 *  of the stored deep link if one was found.
 *
 *  @param loggingEnabled Boolean to indicate whether to enable logging or not. @see SCConfig
 */
- (void)launchWithLoggingEnabled:(BOOL)loggingEnabled;

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
- (SCSession *)startSessionWithURL:(NSURL *)url;

/**
 *  Creates a new short link.
 *
 *  This method creates a new short link in the Shortcut backend with the given parameters. When the item is
 *  created, the method will invoke the completion handler. The new short link's URL will be passed to the
 *  handler. If an error occurs, the handler also gets an error object describing the error.
 *
 *  @param websiteURL The URL of the website the short link points to by default.
 *  @param completionHandler A handler that will be called with the short link URL once the short link is created.
 */
- (void)createShortLinkWithWebsiteURL:(NSURL *)websiteURL
                    completionHandler:(void (^)(NSURL *shortLinkURL, NSError *error))completionHandler;

/**
 *  Creates a new short link.
 *
 *  This method creates a new short link in the Shortcut backend with the given parameters. When the item is
 *  created, the method will invoke the completion handler. The new short link's URL will be passed to the
 *  handler. If an error occurs, the handler also gets an error object describing the error.
 *
 *  @param title The title of the new short link (optional).
 *  @param websiteURL The URL of the website the short link points to by default.
 *  @param completionHandler A handler that will be called with the short link URL once the short link is created.
 */
- (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
               completionHandler:(void (^)(NSURL *shortLinkURL, NSError *error))completionHandler;

/**
 *  Creates a new short (deep) link.
 *
 *  This method creates a new short link in the Shortcut backend with the given parameters. When the item is
 *  created, the method will invoke the completion handler. The new short link's URL will be passed to the
 *  handler. If an error occurs, the handler also gets an error object describing the error.
 *
 *  @param title The title of the new short link (optional).
 *  @param websiteURL The URL of the website the short link points to by default.
 *  @param deepLinkURL The deep link URL the short link should link to on all platforms (optional).
 *  @param completionHandler A handler that will be called with the short link URL once the short link is created.
 */
- (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                     deepLinkURL:(NSURL *)deepLinkURL
               completionHandler:(void (^)(NSURL *shortLinkURL, NSError *error))completionHandler;

/**
 *  Creates a new short (deep) link.
 *
 *  This method creates a new short link in the Shortcut backend with the given parameters. When the item is
 *  created, the method will invoke the completion handler. The new short link's URL will be passed to the
 *  handler. If an error occurs, the handler also gets an error object describing the error.
 *
 *  @param title The title of the new short link (optional).
 *  @param websiteURL The URL of the website the short link points to by default.
 *  @param iOSDeepLinkURL The deep link URL the short link should link to on iOS (optional).
 *  @param androidDeepLinkURL The deep link URL the short link should link to on Android (optional).
 *  @param windowsPhoneDeepLinkURL The deep link URL the short link should link to on Windows Phone (optional).
 *  @param completionHandler A handler that will be called with the short link URL once the short link is created.
 */
- (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                  iOSDeepLinkURL:(NSURL *)iOSDeepLinkURL
              androidDeepLinkURL:(NSURL *)androidDeepLinkURL
         windowsPhoneDeepLinkURL:(NSURL *)windowsPhoneDeepLinkURL
               completionHandler:(void (^)(NSURL *shortLinkURL, NSError *error))completionHandler;

/**
 *  Creates a new short (deep) link.
 *
 *  This method creates a new short link in the Shortcut backend with the given parameters. When the item is
 *  created, the method will invoke the completion handler. The new short link's URL will be passed to the
 *  handler. If an error occurs, the handler also gets an error object describing the error.
 *
 *  @param title The title of the new short link (optional).
 *  @param websiteURL The URL of the website the short link points to by default.
 *  @param iOSAppStoreURL The store URL of the iOS app that should be used to handle the new short link (optional).
 *  @param iOSDeepLinkURL The deep link URL the short link should link to on iOS (optional).
 *  @param androidAppStoreURL The store URL of the Android app that should be used to handle the new short link (optional).
 *  @param androidDeepLinkURL The deep link URL the short link should link to on Android (optional).
 *  @param windowsPhoneAppStoreURL The store URL of the Windows Phone app that should be used to handle the new short link (optional).
 *  @param windowsPhoneDeepLinkURL The deep link URL the short link should link to on Windows Phone (optional).
 *  @param completionHandler A handler that will be called with the short link URL once the short link is created.
 */
- (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                  iOSAppStoreURL:(NSURL *)iOSAppStoreURL
                  iOSDeepLinkURL:(NSURL *)iOSDeepLinkURL
              androidAppStoreURL:(NSURL *)androidAppStoreURL
              androidDeepLinkURL:(NSURL *)androidDeepLinkURL
         windowsPhoneAppStoreURL:(NSURL *)windowsPhoneAppStoreURL
         windowsPhoneDeepLinkURL:(NSURL *)windowsPhoneDeepLinkURL
               completionHandler:(void (^)(NSURL *shortLinkURL, NSError *error))completionHandler;


/// @name Configuration accessors

/**
 *  This token is used for authentication with the Shortcut backend.
 *
 *  @see SCConfig -authToken
 */
- (void)setAuthToken:(NSString *)token;

/**
 *  By default the some debug information is logged. Use this property to turn off this logging.
 *
 *  @see SCConfig -loggingEnabled
 */
- (void)setLoggingEnabled:(BOOL)enabled;

@end
