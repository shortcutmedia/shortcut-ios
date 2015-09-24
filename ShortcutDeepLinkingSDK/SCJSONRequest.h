//
//  SCJSONRequest.h
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCJSONRequest : NSObject

+ (void)postToURL:(NSURL *)url
           params:(NSDictionary *)params
completionHandler:(void (^)(NSURLResponse *response, NSDictionary *content, NSError *error))completionHandler;

@end
