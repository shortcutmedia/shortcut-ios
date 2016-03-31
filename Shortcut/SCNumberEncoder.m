//
//  SCNumberEncoder.m
//  Shortcut
//
//  Created by Severin Schoepke on 22/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import "SCNumberEncoder.h"

NSString * const kSCNumberEncoderBase62 = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

@interface SCNumberEncoder ()

@property (strong, nonatomic, readwrite) NSString *base;

@end

@implementation SCNumberEncoder

- (instancetype)initWithBase:(NSString *)base {
    self = [super init];
    
    if (self) {
        self.base = base;
    }
    
    return self;
}

+ (instancetype)base62Encoder {
    return [[self alloc] initWithBase:kSCNumberEncoderBase62];
}

- (NSUInteger)baseNumber {
    return self.base.length;
}

- (NSString *)encode:(NSUInteger)number {
    NSArray *convertedNumbers = [self convert:number];
    
    char cString[convertedNumbers.count + 1];
    cString[convertedNumbers.count] = '\0';
    
    const char *cBase = [self.base UTF8String];
    
    for(NSUInteger i = 0; i < convertedNumbers.count; i++) {
        NSNumber *convertedNumber = (NSNumber *)[convertedNumbers objectAtIndex:i];
        cString[i] = cBase[[convertedNumber unsignedIntegerValue]];
    }

    return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
}

- (NSUInteger)decode:(NSString *)string {
    NSUInteger number = 0;
    
    NSUInteger stringLength = string.length;
    const char *cString = [string UTF8String];
    
    NSUInteger baseLength = self.base.length;
    const char *cBase = [self.base UTF8String];
    
    for (NSUInteger i = 0; i < stringLength; i++) {
        const char character = cString[i];
        NSUInteger index;
        for (index = 0; index < baseLength; index++) {
            if (cBase[index] == character) { break; }
        }
        NSUInteger f = stringLength - 1 - i;
        
        number = number + (index * pow(self.baseNumber,f));
    }
    
    return number;
}

- (NSArray *)convert:(NSUInteger)number {
    NSMutableArray *converted = [NSMutableArray array];
    
    while (number > 0) {
        NSUInteger quotient = number / [self baseNumber];
        NSUInteger reminder = number % [self baseNumber];
        number = quotient;
        [converted addObject:@(reminder)];
    }
    
    if (converted.count == 0) {
        return [NSArray arrayWithObject:@(0)];
    } else {
        return [[converted reverseObjectEnumerator] allObjects];
    }
}

@end
