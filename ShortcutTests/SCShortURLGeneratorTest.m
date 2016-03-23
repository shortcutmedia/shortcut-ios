//
//  SCShortURLGeneratorTest.m
//  Shortcut
//
//  Created by Severin Schoepke on 23/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCShortURLGenerator.h"
#import "SCConfig.h"

@interface SCShortURLGeneratorTest : XCTestCase

@property (strong, nonatomic) SCShortURLGenerator *generator;

@property (strong, nonatomic) NSString *configAuthTokenBefore;
@property (strong, nonatomic) NSString *configShortLinkDomainBefore;

@end

@implementation SCShortURLGeneratorTest

- (void)setUp {
    [super setUp];
    
    // Keep config values to restor them in teardown
    self.configAuthTokenBefore = [SCConfig sharedConfig].authToken;
    self.configShortLinkDomainBefore = [SCConfig sharedConfig].shortLinkDomain;
    
    self.generator = [[SCShortURLGenerator alloc] init];
}

- (void)tearDown {
    // Restore saved config values
    [SCConfig sharedConfig].authToken = self.configAuthTokenBefore;
    [SCConfig sharedConfig].shortLinkDomain = self.configShortLinkDomainBefore;
    
    [super tearDown];
}

- (void)test_generate {
    [SCConfig sharedConfig].authToken = @"abcdef";
    
    NSURL *generatedURL = [self.generator generate];
    
    XCTAssertEqualObjects(generatedURL.scheme, @"http");
    XCTAssertEqualObjects(generatedURL.host, [SCConfig sharedConfig].shortLinkDomain);
    XCTAssertEqual(generatedURL.path.length, 11); // path includes leading "/"
}

- (void)test_generate_withCustomDomain {
    [SCConfig sharedConfig].authToken       = @"abcdef";
    [SCConfig sharedConfig].shortLinkDomain = @"short.li";
    
    NSURL *generatedURL = [self.generator generate];
    
    XCTAssertEqualObjects(generatedURL.scheme, @"http");
    XCTAssertEqualObjects(generatedURL.host, [SCConfig sharedConfig].shortLinkDomain);
    XCTAssertEqual(generatedURL.path.length, 8); // path includes leading "/"
}

@end
