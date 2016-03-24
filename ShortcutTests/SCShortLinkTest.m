//
//  SCShortLinkTest.m
//  Shortcut
//
//  Created by Severin Schoepke on 24/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCShortLink.h"

@interface SCShortLinkTest : XCTestCase

@property SCShortLink *shortLink;

@end

@implementation SCShortLinkTest

- (void)setUp {
    [super setUp];
    
    self.shortLink = [[SCShortLink alloc] init];
}

- (void)test_generateShortURL_whenNoShortURLPresent {
    // precondition:
    XCTAssertNil(self.shortLink.shortURL);
    
    [self.shortLink generateShortURL];
    
    XCTAssertNotNil(self.shortLink.shortURL);
}

- (void)test_generateShortURL_whenShortURLPresent {
    [self.shortLink generateShortURL];
    
    // precondition:
    XCTAssertNotNil(self.shortLink.shortURL);
    
    NSURL *existingShortURL = self.shortLink.shortURL;
    
    [self.shortLink generateShortURL];
    
    XCTAssertEqualObjects(self.shortLink.shortURL, existingShortURL);
}

@end
