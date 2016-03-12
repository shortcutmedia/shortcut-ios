//
//  SCJSONRequest.h
//  Shortcut
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The SCJSONRequest class allows to send HTTP JSON requests.
 */
@interface SCJSONRequest : NSObject

/**
 *  This method sends a POST request with the given params to the given URL.
 *
 *  @param url The URL to send the request to.
 *  @param params A dictionary containing the payload of the request.
 *  @param completionHandler A callback that will be called with the response of the request. The content parameter passed to it contains the already parsed body of the response.
 */
+ (void)postToURL:(NSURL *)url
           params:(NSDictionary *)params
completionHandler:(void (^)(NSURLResponse *response, NSDictionary *content, NSError *error))completionHandler;

@end
