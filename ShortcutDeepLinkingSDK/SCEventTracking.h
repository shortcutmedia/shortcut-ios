//
//  SCEventTracking.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 15/02/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The SCEventTracking class acts as central interaction point with the ShortcutDeepLinkingSDK
 *  for all event tracking concerns.
 *
 *  @discussion
 *  It is implemented as a singleton: Use the SCEventTracking +sharedInstance method to get the
 *  singleton instance.
 */
@interface SCEventTracking : NSObject


/// @name Accessing the global instance

/**
 *  This class is a singleton. You cannot instantiate new instances.
 *  Use the SCEventTracking +sharedInstance method to get the singleton instance.
 */
- (instancetype)init __attribute__((unavailable("use SCEventTracking +sharedInstance")));

/**
 *  Returns the singleton instance.
 *
 *  @return The global instance.
 */
+ (instancetype)sharedInstance;


/// @name Interactions

/**
 *  Takes care of setting up notification listeners and collecting launch events.
 *
 *  This method should be called in the app delegate's application:didFinishLaunchingWithOptions:
 *  It sets up notification handlers that track different events based on OS notifications. It also
 *  tracks some launch-related events.
 */
- (void)launch;

/**
 *  Takes care of setting up notification listeners and collecting launch events.
 *
 *  This method should be called in the app delegate's application:didFinishLaunchingWithOptions:
 *  It sets up notification handlers that track different events based on OS notifications. It also
 *  tracks some launch-related events.
 *
 *  @param authToken The token to use for authentication with the Shortcut backend. @see SCConfig
 */
- (void)launchWithAuthToken:(NSString *)authToken;

/**
 *  Takes care of setting up notification listeners and collecting launch events.
 *
 *  This method should be called in the app delegate's application:didFinishLaunchingWithOptions:
 *  It sets up notification handlers that track different events based on OS notifications. It also
 *  tracks some launch-related events.
 *
 *  @param loggingEnabled Boolean to indicate whether to enable logging or not. @see SCConfig
 */
- (void)launchWithLoggingEnabled:(BOOL)loggingEnabled;


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
