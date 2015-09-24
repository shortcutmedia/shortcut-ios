//
//  SCLinkIDExtractor.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLinkIDExtractor : NSObject

- (NSString *)linkIDFromURL:(NSURL *)url;
- (NSURL *)URLWithoutLinkID:(NSURL *)url;

extern NSString *kLinkIDParamString;

@end
