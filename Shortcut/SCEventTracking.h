//
//  SCEventTracking.h
//  Shortcut
//
//  Created by Severin Schoepke on 15/02/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The SCEventTracking class acts as central interaction point with the SDK for all event tracking concerns.
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


@end
