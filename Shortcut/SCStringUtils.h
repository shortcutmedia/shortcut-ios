//
//  SCStringUtils.h
//  Shortcut
//
//  Created by Severin Schoepke on 24/03/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCStringUtils : NSObject

/**
 * This method base62-decodes the string, rotates it the given number of times,
 * and base62-reencodes it.
 */
+ (NSString *)rotate:(NSString *)string times:(NSInteger)num;

/**
 * This method pads the string with the given pad on the left so that it will be at
 * least of the given length.
 */
+ (NSString *)rjustString:(NSString *)string withPad:(NSString *)pad toLength:(NSUInteger)length;

@end
