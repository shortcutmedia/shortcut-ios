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
        @"platform" :        @"iOS",
        @"platformVersion" : [[UIDevice currentDevice] systemVersion],
        @"platformBuild" :   [self systemBuildVersion],
        @"device" :          [[UIDevice currentDevice] model],
        @"device_id" :       [self deviceID],
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
