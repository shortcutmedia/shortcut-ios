//
//  SCNumberEncoderTest.m
//  Shortcut
//
//  Created by Severin Schoepke on 22/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCNumberEncoder.h"

@interface SCNumberEncoderTest : XCTestCase

@property (strong, nonatomic) SCNumberEncoder *encoder;

@end

@implementation SCNumberEncoderTest


- (void)test_encode {
    self.encoder = [[SCNumberEncoder alloc] initWithBase:@"abcdef"];
    
    XCTAssertEqualObjects([self.encoder encode:0],    @"a");
    XCTAssertEqualObjects([self.encoder encode:1],    @"b");
    XCTAssertEqualObjects([self.encoder encode:2],    @"c");
    XCTAssertEqualObjects([self.encoder encode:3],    @"d");
    XCTAssertEqualObjects([self.encoder encode:4],    @"e");
    XCTAssertEqualObjects([self.encoder encode:5],    @"f");
    XCTAssertEqualObjects([self.encoder encode:6],    @"ba");
    XCTAssertEqualObjects([self.encoder encode:7],    @"bb");
    XCTAssertEqualObjects([self.encoder encode:8],    @"bc");
    XCTAssertEqualObjects([self.encoder encode:12],   @"ca");
    XCTAssertEqualObjects([self.encoder encode:35],   @"ff");
    XCTAssertEqualObjects([self.encoder encode:36],   @"baa");
    XCTAssertEqualObjects([self.encoder encode:37],   @"bab");
    XCTAssertEqualObjects([self.encoder encode:38],   @"bac");
    XCTAssertEqualObjects([self.encoder encode:215],  @"fff");
    XCTAssertEqualObjects([self.encoder encode:216],  @"baaa");
    XCTAssertEqualObjects([self.encoder encode:1296], @"baaaa");
    XCTAssertEqualObjects([self.encoder encode:7776], @"baaaaa");
}

- (void)test_decode {
    self.encoder = [[SCNumberEncoder alloc] initWithBase:@"abcdef"];
    
    XCTAssertEqual([self.encoder decode:@"a"],      0);
    XCTAssertEqual([self.encoder decode:@"b"],      1);
    XCTAssertEqual([self.encoder decode:@"c"],      2);
    XCTAssertEqual([self.encoder decode:@"d"],      3);
    XCTAssertEqual([self.encoder decode:@"e"],      4);
    XCTAssertEqual([self.encoder decode:@"f"],      5);
    XCTAssertEqual([self.encoder decode:@"ba"],     6);
    XCTAssertEqual([self.encoder decode:@"bb"],     7);
    XCTAssertEqual([self.encoder decode:@"bc"],     8);
    XCTAssertEqual([self.encoder decode:@"ca"],     12);
    XCTAssertEqual([self.encoder decode:@"ff"],     35);
    XCTAssertEqual([self.encoder decode:@"baa"],    36);
    XCTAssertEqual([self.encoder decode:@"bab"],    37);
    XCTAssertEqual([self.encoder decode:@"bac"],    38);
    XCTAssertEqual([self.encoder decode:@"fff"],    215);
    XCTAssertEqual([self.encoder decode:@"baaa"],   216);
    XCTAssertEqual([self.encoder decode:@"baaaa"],  1296);
    XCTAssertEqual([self.encoder decode:@"baaaaa"], 7776);
}

- (void)test_base62Encoder {
    self.encoder = [SCNumberEncoder base62Encoder];
    
    XCTAssertEqualObjects(self.encoder.base, @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
    XCTAssertEqual(self.encoder.baseNumber, 62);
}

- (void)test_encode_base62 {
    self.encoder = [SCNumberEncoder base62Encoder];
    
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 0) - 1)], @"0");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 1) - 1)], @"Z");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 1) - 0)], @"10");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 2) - 1)], @"ZZ");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 2) - 0)], @"100");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 3) - 1)], @"ZZZ");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 3) - 0)], @"1000");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 4) - 1)], @"ZZZZ");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 4) - 0)], @"10000");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 5) - 1)], @"ZZZZZ");
    XCTAssertEqualObjects([self.encoder encode:(pow(62, 5) - 0)], @"100000");
}

- (void)test_decode_base62 {
    self.encoder = [SCNumberEncoder base62Encoder];
    
    XCTAssertEqual([self.encoder decode:@"0"],      (pow(62, 0) - 1));
    XCTAssertEqual([self.encoder decode:@"Z"],      (pow(62, 1) - 1));
    XCTAssertEqual([self.encoder decode:@"10"],     (pow(62, 1) - 0));
    XCTAssertEqual([self.encoder decode:@"ZZ"],     (pow(62, 2) - 1));
    XCTAssertEqual([self.encoder decode:@"100"],    (pow(62, 2) - 0));
    XCTAssertEqual([self.encoder decode:@"ZZZ"],    (pow(62, 3) - 1));
    XCTAssertEqual([self.encoder decode:@"1000"],   (pow(62, 3) - 0));
    XCTAssertEqual([self.encoder decode:@"ZZZZ"],   (pow(62, 4) - 1));
    XCTAssertEqual([self.encoder decode:@"10000"],  (pow(62, 4) - 0));
    XCTAssertEqual([self.encoder decode:@"ZZZZZ"],  (pow(62, 5) - 1));
    XCTAssertEqual([self.encoder decode:@"100000"], (pow(62, 5) - 0));
}

@end
