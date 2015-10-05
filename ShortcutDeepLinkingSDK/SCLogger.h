//
//  SCLogger.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 05/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLogger : NSObject

@property (assign, nonatomic) BOOL enabled;

- (instancetype)init __attribute__((unavailable("use SCLogger +sharedLogger")));
+ (instancetype)sharedLogger;

+ (void)log:(NSString *)message;
- (void)log:(NSString *)message;

@end
