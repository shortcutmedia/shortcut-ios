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

@implementation SCDeviceFingerprint

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"platform" :        @"iOS",
        @"platformVersion" : [[UIDevice currentDevice] systemVersion],
        @"platformBuild" :   [self systemBuildVersion],
        @"device" :          [[UIDevice currentDevice] model],
    };
}


- (NSString *)systemBuildVersion {
    int mib[2] = {CTL_KERN, KERN_OSVERSION};
    size_t size = 0;
    
    // Get the size for the buffer
    sysctl(mib, 2, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctl(mib, 2, answer, &size, NULL, 0);
    
    NSString *result = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return result;
}

@end
