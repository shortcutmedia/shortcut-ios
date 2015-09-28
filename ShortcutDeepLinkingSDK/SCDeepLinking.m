//
//  ShortcutDeepLinkingSDK.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import "SCDeepLinking.h"

#import <UIKit/UIKit.h>

NSString * const kAlreadyLaunchedKey = @"sc.shortcut.AlreadyLaunched";

@interface SCDeepLinking ()

@property (strong, nonatomic) SCSession *firstOpenSession;

@end


@implementation SCDeepLinking


#pragma mark - Singleton instance

+ (instancetype)sharedInstance {
    static SCDeepLinking* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


#pragma mark - Interactions

- (void)launch {
    BOOL firstLaunch = [self checkForFirstLaunch];
    if (!firstLaunch) {
        return;
    }
    
    self.firstOpenSession = [[SCSession alloc] init];
    
    [self.firstOpenSession firstLaunchLookupWithCompletionHandler:^{
        [[UIApplication sharedApplication] openURL:self.firstOpenSession.url];
    }];
}


- (SCSession *)startSessionWithURL:(NSURL *)url {
    
    SCSession *session = nil;
    
    if (self.firstOpenSession && [self.firstOpenSession.url isEqual:url]) {
        session = self.firstOpenSession;
        self.firstOpenSession = nil;
    } else {
        session = [[SCSession alloc] initWithURL:url];
        [session start];
    }
    
    return session;
}


#pragma mark - Helpers

- (BOOL)checkForFirstLaunch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL alreadyLaunched = [defaults boolForKey:kAlreadyLaunchedKey];
    if (!alreadyLaunched) {
        [defaults setBool:YES forKey:kAlreadyLaunchedKey];
        [defaults synchronize];
    }
    
    return !alreadyLaunched;
}

@end

