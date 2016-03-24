//
//  SCStringUtils.m
//  Shortcut
//
//  Created by Severin Schoepke on 24/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import "SCStringUtils.h"

#import "SCNumberEncoder.h"

@implementation SCStringUtils

+ (NSString *)rotate:(NSString *)string times:(NSInteger)num {
    if (string.length < 1) {
        return string;
    }
    
    SCNumberEncoder *encoder = [SCNumberEncoder base62Encoder];
    
    NSUInteger decoded = [encoder decode:string];
    
    NSUInteger max = pow(encoder.baseNumber, string.length);
    NSUInteger value;
    if ((NSInteger)decoded + num < 0) {
        value = max + decoded + num;
    } else {
        value = decoded + num;
    }
    
    NSString *encoded = [encoder encode:(value%max)];
    
    return [self rjustString:encoded withPad:@"0" toLength:string.length];
}

+ (NSString *)rjustString:(NSString *)string withPad:(NSString *)pad toLength:(NSUInteger)length {
    while (string && string.length < length) {
        string = [NSString stringWithFormat:@"%@%@", pad, string];
    }
    return string;
}

@end
