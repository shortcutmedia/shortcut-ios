//
//  SCLinkIDExtractorTest.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCLinkIDExtractor.h"

@interface SCLinkIDExtractorTest : XCTestCase

@property (strong, nonatomic) SCLinkIDExtractor *linkIDExtractor;

@end

@implementation SCLinkIDExtractorTest

- (void)setUp {
    [super setUp];
    
    self.linkIDExtractor = [[SCLinkIDExtractor alloc] init];
}

- (void)test_linkIDFromURL {
    NSURL *url;
    NSString *expectedLinkID;
    
    url = [NSURL URLWithString:@"sc.shortcut://foo?sc_link_id=123"];
    expectedLinkID = @"123";
    XCTAssertEqualObjects([self.linkIDExtractor linkIDFromURL:url], expectedLinkID);
    
    url = [NSURL URLWithString:@"sc.shortcut://foo?foo=bar&sc_link_id=456"];
    expectedLinkID = @"456";
    XCTAssertEqualObjects([self.linkIDExtractor linkIDFromURL:url], expectedLinkID);
    
    url = [NSURL URLWithString:@"sc.shortcut://foo?foo=bar"];
    expectedLinkID = nil;
    XCTAssertEqualObjects([self.linkIDExtractor linkIDFromURL:url], expectedLinkID);
}

- (void)test_URLWithoutLinkID {
    NSURL *url, *expectedURL;
    
    url = [NSURL URLWithString:@"sc.shortcut://foo?sc_link_id=123"];
    expectedURL = [NSURL URLWithString:@"sc.shortcut://foo"];
    XCTAssertEqualObjects([self.linkIDExtractor URLWithoutLinkID:url], expectedURL);
    
    url = [NSURL URLWithString:@"sc.shortcut://foo?foo=bar&sc_link_id=456"];
    expectedURL = [NSURL URLWithString:@"sc.shortcut://foo?foo=bar"];
    XCTAssertEqualObjects([self.linkIDExtractor URLWithoutLinkID:url], expectedURL);
    
    url = [NSURL URLWithString:@"sc.shortcut://foo?foo=bar"];
    expectedURL = [NSURL URLWithString:@"sc.shortcut://foo?foo=bar"];
    XCTAssertEqualObjects([self.linkIDExtractor URLWithoutLinkID:url], expectedURL);
}

@end
