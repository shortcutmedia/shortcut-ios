//
//  ShortcutDeepLinkingSDK.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import "SCDeepLinking.h"

#import <UIKit/UIKit.h>
#import "SCLinkIDExtractor.h"
#import "SCJSONRequest.h"

NSString * const kFirstOpenURLString = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/first_open";
NSString * const kOpenURLString      = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/open";
NSString * const kAlreadyLaunchedKey = @"sc.shortcut.AlreadyLaunched";


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
    
    [SCJSONRequest postToURL:[NSURL URLWithString:kFirstOpenURLString] params:nil completionHandler:^(NSURLResponse *response, NSDictionary *content, NSError *error) {
        if (error) {
            NSLog(@"error: %@", [error description]);
        } else {
            if ([content[@"uri"] isKindOfClass:NSString.class]) {
                NSURL *deepLinkURL = [NSURL URLWithString:content[@"uri"]];
                
                SCLinkIDExtractor *linkIDExtractor = [[SCLinkIDExtractor alloc] init];
                deepLinkURL = [linkIDExtractor URLWithoutLinkID:deepLinkURL];
                
                if ([deepLinkURL absoluteString].length) {
                    [[UIApplication sharedApplication] openURL:deepLinkURL];
                }
            }
        }
    }];
}


- (NSURL *)handleOpenURL:(NSURL *)url {
    
    SCLinkIDExtractor *linkIDExtractor = [[SCLinkIDExtractor alloc] init];
    
    NSString *linkId = [linkIDExtractor linkIDFromURL:url];
    
    if (linkId) {
        [SCJSONRequest postToURL:[NSURL URLWithString:kOpenURLString] params:@{kLinkIDParamString : linkId} completionHandler:^(NSURLResponse *response, NSDictionary *content, NSError *error) {
            if (error) {
                NSLog(@"error: %@", [error description]);
            }
        }];
    }
        
    return [linkIDExtractor URLWithoutLinkID:url];
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

