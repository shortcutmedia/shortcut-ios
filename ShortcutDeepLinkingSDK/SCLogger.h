//
//  SCLogger.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 05/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The SCLogger class allows to log debug messages.
 *
 *  @discussion
 *  It is implemented as a singleton: Use the SCLogger +sharedLogger method to get the
 *  singleton instance.
 */
@interface SCLogger : NSObject

/// @name Accessing the global instance

/**
 *  This class is a singleton. You cannot instantiate new instances.
 *  Use the SCLogger +sharedLogger method to get the singleton instance.
 */
- (instancetype)init __attribute__((unavailable("use SCLogger +sharedLogger")));

/**
 *  Returns the singleton instance.
 *
 *  @return The global logger instance.
 */
+ (instancetype)sharedLogger;

/// @name Logging

/**
 *  Logs the given message if logging is enabled.
 *
 *  This is just a convenience shortcut for [[SCLogger sharedLogger] log:@"some message"].
 */
+ (void)log:(NSString *)message;

/**
 *  Logs the given message if logging is enabled.
 */
- (void)log:(NSString *)message;

@end
