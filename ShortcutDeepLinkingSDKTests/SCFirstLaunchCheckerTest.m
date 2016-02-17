//
//  SCFirstLaunchCheckerTest.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 15/02/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCFirstLaunchChecker.h"

@interface SCFirstLaunchCheckerTest : XCTestCase

@property (strong, nonatomic) SCFirstLaunchChecker *firstLaunchChecker;

@end

@implementation SCFirstLaunchCheckerTest

- (void)setUp {
    [super setUp];
    
    self.firstLaunchChecker = [SCFirstLaunchChecker sharedInstance];
    
    // Resetting the statusDetermined flag for each test run
    // Beware: ugly ;)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.firstLaunchChecker performSelector:NSSelectorFromString(@"setStatusDetermined:") withObject:@(NO)];
#pragma clang diagnostic pop
}

- (void)test_isFirstLaunch_whenNotLaunchedBefore {
    // precondition:
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sc.shortcut.AlreadyLaunched"];
    
    // it should return YES
    XCTAssertTrue(self.firstLaunchChecker.isFirstLaunch);
    
    // it should stay the same until the app is restarted
    XCTAssertTrue(self.firstLaunchChecker.isFirstLaunch);
}

- (void)test_isFirstLaunch_whenLaunchedBefore {
    // precondition:
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sc.shortcut.AlreadyLaunched"];
    
    // it should return NO
    XCTAssertFalse(self.firstLaunchChecker.isFirstLaunch);
}

@end
