//
//  SCDeepLinkOpener.h
//  Shortcut
//
//  Created by Severin Schoepke on 07/01/16.
//  Copyright © 2016 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDeepLinkOpener : NSObject

/**
 *  Opens a deep link in the app.
 *
 *  @param url The URL of the deep link to open.
 */
- (void)openURL:(NSURL *)url;

@end
