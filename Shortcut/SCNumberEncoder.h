//
//  SCNumberEncoder.h
//  Shortcut
//
//  Created by Severin Schoepke on 22/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNumberEncoder : NSObject

@property (strong, nonatomic, readonly) NSString *base;
@property (nonatomic, readonly) NSUInteger baseNumber;

- (instancetype)initWithBase:(NSString *)base;
- (instancetype)init __attribute__((unavailable("use SCNumberEncoder -initWithBase:")));

+ (instancetype)base62Encoder;

- (NSString *)encode:(NSUInteger)number;
- (NSUInteger)decode:(NSString *)string;

@end
