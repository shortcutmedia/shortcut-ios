//
//  SCLogger.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 05/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCLogger.h"

@implementation SCLogger

+ (instancetype)sharedLogger {
    static SCLogger *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enabled = YES;
    }
    return self;
}

+ (void)log:(NSString *)message {
    [[self sharedLogger] log:message];
}

- (void)log:(NSString *)message {
    if (self.enabled) {
        NSLog(@"[ShortcutDeepLinkingSDK]: %@", message);
    }
}

@end
