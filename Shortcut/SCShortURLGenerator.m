//
//  SCShortURLGenerator.m
//  Shortcut
//
//  Created by Severin Schoepke on 23/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import "SCShortURLGenerator.h"

#import "SCNumberEncoder.h"
#import "SCConfig.h"

#include <stdlib.h>

NSUInteger const kSCShortURLGeneratorKeyLength    = 3;
NSUInteger const kSCShortURLGeneratorRandomLength = 2;
NSUInteger const kSCShortURLGeneratorTimeLength   = 5;

NSUInteger const kSCShortURLGeneratorEpoch = 1456790400; // 2016-03-01 00:00:00 (utc)

@interface SCShortURLGenerator ()

@property (strong, nonatomic) SCNumberEncoder *encoder;

@end

@implementation SCShortURLGenerator

- (SCNumberEncoder *)encoder {
    if (!_encoder) {
        _encoder = [SCNumberEncoder base62Encoder];
    }
    
    return _encoder;
}

- (NSURL *)generate {
    NSString *scheme = @"http";
    NSString *domain = [SCConfig sharedConfig].shortLinkDomain;
    NSString *path   = [self generatePath];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/%@", scheme, domain, path]];
}

- (NSString *)generatePath {
    NSUInteger random = [self generateRandom];
    
    NSString *keyPart    = [self rotate:[self generateKeyPart]
                                  times:random];
    NSString *randomPart = [self rjustString:[self.encoder encode:random]
                                     withPad:@"0"
                                    toLength:kSCShortURLGeneratorRandomLength];
    NSString *timePart   = [self rjustString:[self.encoder encode:[self secondsSinceGeneratorEpoch]]
                                     withPad:@"0"
                                    toLength:kSCShortURLGeneratorTimeLength];
    
    return [NSString stringWithFormat:@"%@%@%@", keyPart, randomPart, timePart];
}

- (NSString *)generateKeyPart {
    SCConfig *config = [SCConfig sharedConfig];
    
    NSString *keyPart;
    
    if ([config.shortLinkDomain isEqualToString:config.defaultShortLinkDomain]) {
        keyPart = [config.authToken substringToIndex:kSCShortURLGeneratorKeyLength];
    } else {
        keyPart = @"";
    }
    
    return keyPart;
}

#pragma mark - Helpers

/**
 * @return A pseudo-random uniformly distributed number in the half-open range 
 * [1,self.encoder.baseNumber^kSCShortURLGeneratorRandomLength)..
 */
- (NSUInteger)generateRandom {
    return arc4random_uniform(pow(self.encoder.baseNumber, kSCShortURLGeneratorRandomLength) - 1) + 1;
}

- (NSString *)rotate:(NSString *)string times:(NSInteger)num {
    if (string.length < 1) {
        return string;
    }
    
    NSUInteger decoded = [self.encoder decode:string];
    
    NSUInteger max = pow(self.encoder.baseNumber, string.length);
    NSUInteger value;
    if ((NSInteger)decoded + num < 0) {
        value = max + decoded + num;
    } else {
        value = decoded + num;
    }
    
    NSString *encoded = [self.encoder encode:(value%max)];
    
    return [self rjustString:encoded withPad:@"0" toLength:string.length];
}

- (NSString *)rjustString:(NSString *)string withPad:(NSString *)pad toLength:(NSUInteger)length {
    while (string.length < length) {
        string = [NSString stringWithFormat:@"%@%@", pad, string];
    }
    return string;
}

- (NSUInteger)secondsSinceGeneratorEpoch {
    NSTimeInterval secondsSinceUNIXEpoch = [[NSDate date] timeIntervalSince1970];
    return secondsSinceUNIXEpoch - kSCShortURLGeneratorEpoch;
}

@end
