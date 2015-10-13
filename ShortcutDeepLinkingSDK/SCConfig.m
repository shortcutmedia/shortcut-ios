//
//  SCConfig.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 13/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCConfig.h"

@implementation SCConfig

+ (instancetype)sharedConfig {
    static SCConfig *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues {
    
    self.loggingEnabled = YES;
}

@end
