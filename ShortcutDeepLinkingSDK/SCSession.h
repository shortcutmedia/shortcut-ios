//
//  SCSession.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 25/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSession : NSObject

@property (strong, nonatomic, readonly) NSURL *url;
@property (strong, nonatomic, readonly) NSString *sessionID;

- (instancetype)init;
- (instancetype)initWithURL:(NSURL *)url;

- (void)firstLaunchLookupWithCompletionHandler:(void (^)())completionHandler;
- (void)start;
- (void)finish;

@end
