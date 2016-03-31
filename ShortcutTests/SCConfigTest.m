//
//  SCConfigTest.m
//  Shortcut
//
//  Created by Severin Schoepke on 30/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCConfig.h"

@interface SCConfigTest : XCTestCase

@property (strong, nonatomic) NSString *configAuthTokenBefore;
@property (strong, nonatomic) NSString *configShortLinkDomainBefore;

@end

@implementation SCConfigTest

- (void)setUp {
    [super setUp];
    
    // Keep config values to restore them in teardown
    self.configAuthTokenBefore = [SCConfig sharedConfig].authToken;
    self.configShortLinkDomainBefore = [SCConfig sharedConfig].shortLinkDomain;
}

- (void)tearDown {
    // Restore saved config values
    [SCConfig sharedConfig].authToken = self.configAuthTokenBefore;
    [SCConfig sharedConfig].shortLinkDomain = self.configShortLinkDomainBefore;
    
    [super tearDown];
}

- (void)test_setShortLinkDomain {
    [SCConfig sharedConfig].shortLinkDomain = @"short.li";
    
    XCTAssertEqualObjects([SCConfig sharedConfig].shortLinkDomain, @"short.li");
}

- (void)test_setShortLinkDomain_withInvalidValue {
    NSString *valueBefore = [SCConfig sharedConfig].shortLinkDomain;
    
    [SCConfig sharedConfig].shortLinkDomain = @"http://invalid.domain";
    XCTAssertEqualObjects([SCConfig sharedConfig].shortLinkDomain, valueBefore);
    
    [SCConfig sharedConfig].shortLinkDomain = nil;
    XCTAssertEqualObjects([SCConfig sharedConfig].shortLinkDomain, valueBefore);
}


@end
