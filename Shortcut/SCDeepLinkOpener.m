//
//  SCDeepLinkOpener.m
//  Shortcut
//
//  Created by Severin Schoepke on 07/01/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import "SCDeepLinkOpener.h"

#import <UIKit/UIKit.h>

@implementation SCDeepLinkOpener

- (void)openURL:(NSURL *)url {
    
    // case 1: the deep link to open is an Universal Link
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        
        // Universal Links are handled as a continuation of a browsing activity. Unfortunately there seems
        // to be no way to trigger an NSUserActivity continuation in the same app, so we just call the delegate
        // callback manually...
        //
        // TODO:  Find a better way to trigger NSUserActivity continuation
        // FIXME: Find out what the restoration handler is supposed to do and implement this behavior in the
        //        block passed to the method below...
        NSUserActivity *universalLinkActivity = [[NSUserActivity alloc] initWithActivityType:NSUserActivityTypeBrowsingWeb];
        universalLinkActivity.webpageURL = url;
        
        [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication]
                                           continueUserActivity:universalLinkActivity
                                             restorationHandler:^(NSArray * _Nullable restorableObjects) {}];
    }
    // case 2: the deep link is a custom-scheme URL
    else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
