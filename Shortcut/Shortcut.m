//
//  Shortcut.m
//  Shortcut
//
//  Created by Severin Schoepke on 12/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import "Shortcut.h"

#import "SCConfig.h"
#import "SCDeepLinking.h"
#import "SCEventTracking.h"
#import <UIKit/UIKit.h>

@implementation Shortcut

+ (void)launchWithAuthToken:(NSString *)authToken {
    NSAssert([UIApplication sharedApplication].applicationState == UIApplicationStateInactive, @"You must invoke [Shortcut launchWithAuthToken:] BEFORE the app becomes active, e.g. in [UIApplicationDelegate application:didFinishLaunchingWithOptions:]");
    
    [[SCConfig sharedConfig] setAuthToken:authToken];
    
    [[SCDeepLinking sharedInstance] launch];
    [[SCEventTracking sharedInstance] launch];
}

+ (SCSession *)startDeepLinkSessionWithURL:(NSURL *)url {
    return [[SCDeepLinking sharedInstance] startSessionWithURL:url];
}

+ (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                        deepLink:(NSURL *)deepLink
               completionHandler:(void (^)(NSURL *, NSError *))completionHandler {
    [self createShortLinkWithTitle:title
                        websiteURL:websiteURL
                       iOSDeepLink:deepLink
                   androidDeepLink:deepLink
              windowsPhoneDeepLink:deepLink
                 completionHandler:completionHandler];
}

+ (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                     iOSDeepLink:(NSURL *)iOSDeepLink
                 androidDeepLink:(NSURL *)androidDeepLink
            windowsPhoneDeepLink:(NSURL *)windowsPhoneDeepLink
               completionHandler:(void (^)(NSURL *, NSError *))completionHandler {
    [[SCDeepLinking sharedInstance] createShortLinkWithTitle:title
                                                  websiteURL:websiteURL
                                              iOSDeepLinkURL:iOSDeepLink
                                          androidDeepLinkURL:androidDeepLink
                                     windowsPhoneDeepLinkURL:windowsPhoneDeepLink
                                           completionHandler:completionHandler];
}

@end
