//
//  SCEventTracking.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 15/02/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import "SCEventTracking.h"

#import <UIKit/UIKit.h>
#import "SCFirstLaunchChecker.h"
#import "SCJSONRequest.h"
#import "SCConfig.h"

NSString * const kSCEventTrackingAppFirstOpenURLString = @"https://shortcut-service.shortcutmedia.com/api/v1/mobile_apps/first_open";
NSString * const kSCEventTrackingAppOpenURLString      = @"https://shortcut-service.shortcutmedia.com/api/v1/mobile_apps/open";

@implementation SCEventTracking

#pragma mark - Singleton instance

+ (instancetype)sharedInstance {
    static SCEventTracking* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


#pragma mark - Interactions

- (void)launch {
    NSAssert([UIApplication sharedApplication].applicationState == UIApplicationStateInactive, @"You must invoke [SCEventTracking launch] BEFORE the app becomes active, e.g. in [UIApplicationDelegate application:didFinishLaunchingWithOptions:]");
;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(trackAppOpen)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)launchWithAuthToken:(NSString *)authToken {
    [self setAuthToken:authToken];
    [self launch];
}

- (void)launchWithLoggingEnabled:(BOOL)loggingEnabled {
    [self setLoggingEnabled:loggingEnabled];
    [self launch];
}


#pragma mark - Config delegators

- (void)setAuthToken:(NSString *)token {
    [SCConfig sharedConfig].authToken = token;
}

- (void)setLoggingEnabled:(BOOL)enabled {
    [SCConfig sharedConfig].loggingEnabled = enabled;
}


#pragma mark - Helpers

- (void)trackAppOpen {
    BOOL firstLaunch = [[SCFirstLaunchChecker sharedInstance] isFirstLaunch];
    
    NSString *eventURLString = firstLaunch ?
        kSCEventTrackingAppFirstOpenURLString :
        kSCEventTrackingAppOpenURLString;
    
    // TODO: should a SCSession be started here??
    
    [SCJSONRequest postToURL:[NSURL URLWithString:eventURLString]
                      params:@{}
           completionHandler:nil];
}

@end
