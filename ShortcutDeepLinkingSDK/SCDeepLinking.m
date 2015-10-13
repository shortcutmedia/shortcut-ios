//
//  ShortcutDeepLinkingSDK.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import "SCDeepLinking.h"

#import <UIKit/UIKit.h>
#import "SCConfig.h"
#import "SCLogger.h"

NSString * const kAlreadyLaunchedKey = @"sc.shortcut.AlreadyLaunched";

@interface SCDeepLinking ()

@property (strong, nonatomic) SCSession *currentSession;

@end


@implementation SCDeepLinking

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopCurrentSession)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


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
    
    [SCLogger log:@"Doing deferred deep link lookup"];
    [SCSession firstLaunchLookupWithCompletionHandler:^(SCSession *session) {
        self.currentSession = session;
        
        if (self.currentSession) {
            [SCLogger log:[NSString stringWithFormat:@"Found deferred deep link: %@",
                           self.currentSession.url.absoluteString]];
            [[UIApplication sharedApplication] openURL:self.currentSession.url];
        } else {
            [SCLogger log:@"Found no deferred deep link"];
        }
    }];
}


- (void)launchWithLoggingEnabled:(BOOL)loggingEnabled {
    [self setLoggingEnabled:loggingEnabled];
    [self launch];
}


- (SCSession *)startSessionWithURL:(NSURL *)url {
    
    // Stop current session if the URL changed
    if (self.currentSession && ![self.currentSession.url isEqual:url]) {
        [self.currentSession finish];
        self.currentSession = nil;
    }
    
    // Start a new current session if necessary
    if (!self.currentSession) {
        self.currentSession = [[SCSession alloc] initWithURL:url];
        [self.currentSession start];
    }
    
    [SCLogger log:[NSString stringWithFormat:@"Starting session for deep link: %@",
                   [self.currentSession.url absoluteString]]];
    
    return self.currentSession;
}


- (void)stopCurrentSession {
    if (self.currentSession) {
        [self.currentSession finish];
        self.currentSession = nil;
    }
}


#pragma mark - Config delegators

- (void)setLoggingEnabled:(BOOL)enabled {
    [SCConfig sharedConfig].loggingEnabled = enabled;
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

