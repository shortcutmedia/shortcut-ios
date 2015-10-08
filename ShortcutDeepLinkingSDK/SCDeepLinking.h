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
 *  @return The global config instance.
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
 *  @param loggingEnabled Boolean to indicate whether to enable logging or not. @see logging
 */
- (void)launchWithLoggingEnabled:(BOOL)loggingEnabled;

/**
 *  Starts a deep link viewing session and returns it.
 *
 *  This method should be called in the app delegate's application:openURL:sourceApplication:annotation:
 *  It creates and starts a deep link viewing session for the given deep link URL. A session spans the time the
 *  user is looking at a deep link and reports the duration to the Shortcut backend if the session was started
 *  by visiting a Shortcut link.
 *  The session's url property contains a URL stripped of all additional query parameters Shortcut needs to
 *  attribute the URL to the correct Shortcut link. So use this URL for further processing.
 *
 *  @return A session describing the viewing of a deep link.
 */
- (SCSession *)startSessionWithURL:(NSURL *)url;


/// @name Debugging helpers

/**
 *  By default the some debug information is logged. Use this property to turn off this logging.
 */
@property (nonatomic) BOOL loggingEnabled;

@end
