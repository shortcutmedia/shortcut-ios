//
//  SCFirstLaunchChecker.m
//  Shortcut
//
//  Created by Severin Schoepke on 15/02/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import "SCFirstLaunchChecker.h"

NSString * const kSCFirstLaunchCheckerAlreadyLaunchedKey = @"sc.shortcut.AlreadyLaunched";

@interface SCFirstLaunchChecker ()

@property (assign, nonatomic) BOOL status;
@property (assign, nonatomic) BOOL statusDetermined;

@end

@implementation SCFirstLaunchChecker

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.statusDetermined = NO;
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static SCFirstLaunchChecker* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - Interactions

- (BOOL)isFirstLaunch {
    if (!self.statusDetermined) {
        [self determineStatus];
    }
    
    return self.status;
}

#pragma mark - Helpers

- (void)determineStatus {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL alreadyLaunched = [defaults boolForKey:kSCFirstLaunchCheckerAlreadyLaunchedKey];
    if (!alreadyLaunched) {
        [defaults setBool:YES forKey:kSCFirstLaunchCheckerAlreadyLaunchedKey];
        [defaults synchronize];
    }
    
    self.status = !alreadyLaunched;
    self.statusDetermined = YES;
}

@end
