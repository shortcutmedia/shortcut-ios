//
//  SCDeviceFingerprintTest.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCDeviceFingerprint.h"

@interface SCDeviceFingerprintTest : XCTestCase

@property (strong, nonatomic) SCDeviceFingerprint *deviceFingerprint;

@end

@implementation SCDeviceFingerprintTest

- (void)setUp {
    [super setUp];
    
    self.deviceFingerprint = [[SCDeviceFingerprint alloc] init];
}

- (void)test_dictionaryRepresentation {
    NSDictionary *result = self.deviceFingerprint.dictionaryRepresentation;
    
    XCTAssertNotNil(result[@"platform"]);
    XCTAssertNotNil(result[@"platformVersion"]);
    XCTAssertNotNil(result[@"platformBuild"]);
    XCTAssertNotNil(result[@"device"]);
}

@end