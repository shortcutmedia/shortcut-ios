//
//  SCStringUtilsTest.m
//  Shortcut
//
//  Created by Severin Schoepke on 24/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCStringUtils.h"

@interface SCStringUtilsTest : XCTestCase

@end

@implementation SCStringUtilsTest

- (void)test_rotate {
    XCTAssertEqualObjects([SCStringUtils rotate:@"00" times:4],  @"04");
    XCTAssertEqualObjects([SCStringUtils rotate:@"ZZ" times:1],  @"00");
    XCTAssertEqualObjects([SCStringUtils rotate:@"ZZ" times:4],  @"03");
    XCTAssertEqualObjects([SCStringUtils rotate:@"03" times:-4], @"ZZ");
    XCTAssertEqualObjects([SCStringUtils rotate:@"00" times:66], @"14");
    XCTAssertEqualObjects([SCStringUtils rotate:@"0"  times:66], @"4");
    
    XCTAssertEqualObjects([SCStringUtils rotate:@"" times:4],  @"");
    XCTAssertEqualObjects([SCStringUtils rotate:nil times:4],  nil);
}

- (void)test_rjust {
    XCTAssertEqualObjects([SCStringUtils rjustString:@"abc" withPad:@"0"  toLength:5], @"00abc");
    XCTAssertEqualObjects([SCStringUtils rjustString:@"abc" withPad:@"0"  toLength:3], @"abc");
    XCTAssertEqualObjects([SCStringUtils rjustString:@"abc" withPad:@"0"  toLength:2], @"abc");
    XCTAssertEqualObjects([SCStringUtils rjustString:@"abc" withPad:@"XY" toLength:5], @"XYabc");
    XCTAssertEqualObjects([SCStringUtils rjustString:@"abc" withPad:@"XY" toLength:6], @"XYXYabc");
    
    XCTAssertEqualObjects([SCStringUtils rjustString:@""    withPad:@"0"  toLength:3], @"000");
    XCTAssertEqualObjects([SCStringUtils rjustString:nil    withPad:@"0"  toLength:3], nil);
}

@end
