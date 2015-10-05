//
//  SCSession.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 25/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  An SCSession object represents a deep link viewing session.
 */
@interface SCSession : NSObject

/**
 *  The deep link URL of the session.
 */
@property (strong, nonatomic, readonly) NSURL *url;

/**
 *  The unique ID of the session.
 */
@property (strong, nonatomic, readonly) NSString *sessionID;


/// @name Initialization

/**
 *  Returns a new session instance for the given deep link URL.
 *
 *  @param url The deep link URL.
 *  @return A new session instance for the given deep link URL.
 */
- (instancetype)initWithURL:(NSURL *)url;


/// @name Operations

/**
 *  Checks if a deferred deep link is available.
 *
 *  This method makes a call to the Shortcut backend and checks whether a deferred deep link
 *  is available for the current device. If a deferred deep link is found, it is assigned as
 *  the session's url property.
 *  When the lookup is finished the callback is called. Within the callback you can check the
 *  session's url property to see if the lookup was successful.
 *
 *  @param completionHandler A callback to be called after the lookup.
 */
- (void)firstLaunchLookupWithCompletionHandler:(void (^)())completionHandler;

/**
 *  Reports the start of a session to the Shortcut backend.
 */
- (void)start;

/**
 *  Reports the end of a session to the Shortcut backend.
 */
- (void)finish;

@end
