//
//  SCDeviceFingerprint.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCDeviceFingerprint.h"

#import <UIKit/UIKit.h>
#include <sys/sysctl.h>

NSString * const kDeviceIDKey = @"sc.shortcut.DeviceID";

@implementation SCDeviceFingerprint

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"platform" :         @"iOS",
        @"platform_version" : [[UIDevice currentDevice] systemVersion],
        @"platform_build" :   [self systemBuildVersion],
        @"device" :           [[UIDevice currentDevice] model],
        @"device_id" :        [self deviceID],
    };
}


- (id)systemBuildVersion {
    static id systemBuildVersionFromUA = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWebView *webView    = [[UIWebView alloc] init];
        NSString *pattern     = @"Mobile\\/([a-zA-Z0-9]+)";
        NSString *parseScript = [NSString stringWithFormat:@"navigator.userAgent.match(/%@/)[1]", pattern];
        
        NSString *uaBuildString = [webView stringByEvaluatingJavaScriptFromString:parseScript];
        if (uaBuildString.length) {
            systemBuildVersionFromUA = uaBuildString;
        } else {
            systemBuildVersionFromUA = [NSNull null];
        }
    });
    
    return systemBuildVersionFromUA;
}

- (NSString *)deviceID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *deviceID = [defaults objectForKey:kDeviceIDKey];
    if (!deviceID) {
        deviceID = [[NSUUID UUID] UUIDString];
        [defaults setValue:deviceID forKey:kDeviceIDKey];
        [defaults synchronize];
    }
    return deviceID;
}

@end
