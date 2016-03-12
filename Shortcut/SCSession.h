//
//  SCSession.h
//  Shortcut
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
 *  Creates a new session from a deferred deep link, if available.
 *
 *  This method makes a call to the Shortcut backend and checks whether a deferred deep link
 *  is available for the current device. If a deferred deep link is found, it is used to create
 *  a new session.
 *  When the lookup is finished the callback is called. The session parameter of the callback is
 *  the newly created session if available, nil otherwise.
 *
 *  @param completionHandler A callback to be called after the lookup. The session parameter
 *  contains a new session for the deferred deep link, if available. It is nil otherwise.
 */
+ (void)firstLaunchLookupWithCompletionHandler:(void (^)(SCSession *session))completionHandler;

/**
 *  Reports the start of a session to the Shortcut backend.
 */
- (void)start;

/**
 *  Reports the end of a session to the Shortcut backend.
 */
- (void)finish;

@end
