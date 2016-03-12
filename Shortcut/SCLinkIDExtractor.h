//
//  SCLinkIDExtractor.h
//  Shortcut
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  An SCLinkIDExtractor object manages Shortcut Link IDs in URLs.
 */
@interface SCLinkIDExtractor : NSObject

/**
 *  Returns the Shortcut Link ID from the URL.
 *
 *  @param The URL to get the Link ID from.
 */
- (NSString *)linkIDFromURL:(NSURL *)url;

/**
 *  Returns a copy of the URL with the Shortcut Link ID removed from it.
 *
 *  @param The URL to remove the Link ID from.
 */
- (NSURL *)URLWithoutLinkID:(NSURL *)url;

/**
 *  Name of the Shortcut Link ID parameter.
 */
extern NSString *kSCLinkIDParamString;

@end
