//
//  ShortcutDeepLinkingSDK.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import "SCDeepLinking.h"

#import <UIKit/UIKit.h>
#import "SCLogger.h"

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
        [SCLogger log:@"Doing no deferred deep link lookup since app is not freshly installed"];
        return;
    }
    
    self.firstOpenSession = [[SCSession alloc] init];
    [SCLogger log:@"Doing deferred deep link lookup"];
    [self.firstOpenSession firstLaunchLookupWithCompletionHandler:^{
        if (self.firstOpenSession.url) {
            [SCLogger log:[NSString stringWithFormat:@"Found deferred deep link: %@",
                           self.firstOpenSession.url.absoluteString]];
            [[UIApplication sharedApplication] openURL:self.firstOpenSession.url];
        } else {
            [SCLogger log:@"Found no deferred deep link"];
        }
    }];
}


- (void)launchWithLoggingEnabled:(BOOL)loggingEnabled {
    self.loggingEnabled = loggingEnabled;
    [self launch];
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
    
    [SCLogger log:[NSString stringWithFormat:@"Starting session for deep link: %@",
                   session.url.absoluteString]];
    
    return session;
}

#pragma mark - Logging

- (BOOL)loggingEnabled {
    return [SCLogger sharedLogger].enabled;
}

- (void)setLoggingEnabled:(BOOL)loggingEnabled {
    [SCLogger sharedLogger].enabled = loggingEnabled;
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

