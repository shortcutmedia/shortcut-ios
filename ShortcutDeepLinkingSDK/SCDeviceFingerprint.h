//
//  SCDeviceFingerprint.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  An SCDeviceFingerprint object represents a fingerprint of a device.
 *
 *  @discussion
 *  A device fingerprint should be as unique as possible. The following properties are
 *  used to generate the fingerprint:
 *  - system information (version and build number)
 *  - device type
 */
@interface SCDeviceFingerprint : NSObject

/**
 *  Returns a dictionary representing the fingerprint.
 *
 *  @return A dictionary representing the fingerprint.
 */
- (NSDictionary *)dictionaryRepresentation;

@end
