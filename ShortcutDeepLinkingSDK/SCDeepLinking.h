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

@end
