//
//  SCLogger.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 05/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCLogger.h"

#import "SCConfig.h"

@implementation SCLogger

+ (instancetype)sharedLogger {
    static SCLogger *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (void)log:(NSString *)message {
    [[self sharedLogger] log:message];
}

- (void)log:(NSString *)message {
    if ([SCConfig sharedConfig].loggingEnabled) {
        NSLog(@"[ShortcutDeepLinkingSDK]: %@", message);
    }
}

@end
