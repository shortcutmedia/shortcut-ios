//
//  ShortcutDeepLinkingSDK.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The SCDeepLinking object acts as central interaction point with the ShortcutDeepLinkingSDK.
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
 */
- (void)launch;

/**
 *  Reports the opening of the URL to the Shortcut backend.
 *
 *  This method should be called in the app delegate's application:openURL:sourceApplication:annotation:
 *  It reports the opening of the deep link to the Shortcut backend if the opening was triggered by visiting
 *  a Shortcut link. It then returns a URL stripped of all additional query parameters Shortcut needs to
 *  attribute the URL to the correct Shortcut link.
 *
 *  @return A sanitized variant of the URL for further processing.
 */
- (NSURL *)handleOpenURL:(NSURL *)url;

@end
