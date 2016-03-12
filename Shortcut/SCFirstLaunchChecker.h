//
//  SCFirstLaunchChecker.h
//  Shortcut
//
//  Created by Severin Schoepke on 15/02/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFirstLaunchChecker : NSObject

/// @name Accessing the global instance

/**
 *  This class is a singleton. You cannot instantiate new instances.
 *  Use the SCFirstLaunchChecker +sharedInstance method to get the singleton instance.
 */
- (instancetype)init __attribute__((unavailable("use SCFirstLaunchChecker +sharedInstance")));

/**
 *  Returns the singleton instance.
 *
 *  @return The global instance.
 */
+ (instancetype)sharedInstance;


/// @name Interactions

/**
 *  Returns YES is the current app launch is the first one.
 */
- (BOOL)isFirstLaunch;

@end
