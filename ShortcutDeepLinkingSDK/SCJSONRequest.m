//
//  SCJSONRequest.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCJSONRequest.h"

#import "SCDeviceFingerprint.h"
#import "SCLogger.h"
#import "SCConfig.h"

@interface SCJSONRequest ()

@property (strong, nonatomic) NSOperationQueue *httpQueue;

@end

@implementation SCJSONRequest

#pragma mark - Properties

- (NSOperationQueue *)httpQueue {
    if (!_httpQueue) {
        _httpQueue = [[NSOperationQueue alloc] init];
    }
    return _httpQueue;
}

#pragma mark - Implementation

+ (void)postToURL:(NSURL *)url
           params:(NSDictionary *)params
completionHandler:(void (^)(NSURLResponse *response, NSDictionary *content, NSError *error))completionHandler {
    
    [[[self alloc] init] postToURL:url params:params completionHandler:completionHandler];
}

- (void)postToURL:(NSURL *)url
           params:(NSDictionary *)params
completionHandler:(void (^)(NSURLResponse *response, NSDictionary *content, NSError *error))completionHandler {
    
    // Build body content (params + fingerprint)
    NSMutableDictionary *bodyContent = [[NSMutableDictionary alloc] init];
    [bodyContent addEntriesFromDictionary:[[[SCDeviceFingerprint alloc] init] dictionaryRepresentation]];
    [bodyContent addEntriesFromDictionary:params];
    
    // Build JSON request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL        = url;
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyContent options:0 error:NULL];
    
    [self logRequest:request];
    
    // Send request
    [NSURLConnection sendAsynchronousRequest:request queue:[self httpQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [self logResponse:response data:data error:error forRequest:request];
        
        // Handle response
        NSDictionary *content = nil;
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if ([json isKindOfClass:NSDictionary.class]) {
                content = (NSDictionary *)json;
            }
        }
        
        if (completionHandler) {
            completionHandler(response, content, error);
        }
    }];
}


#pragma mark - Logging

- (void)logRequest:(NSURLRequest *)request {
#ifdef DEBUG
    [SCLogger log:[NSString stringWithFormat:@"Sending request %@ %@",
                   request.HTTPMethod, request.URL]];
    
    if (request.HTTPBody.length) {
        [SCLogger log:[NSString stringWithFormat:@"Request data: %@",
                       [NSString stringWithUTF8String:request.HTTPBody.bytes]]];
    }
#endif
}

- (void)logResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error forRequest:(NSURLRequest *)request {
#ifdef DEBUG
    if ([response isKindOfClass:NSHTTPURLResponse.class]) {
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        [SCLogger log:[NSString stringWithFormat:@"Received response for request %@ %@: %ld",
                       request.HTTPMethod, request.URL, (long)statusCode]];
        
        if (data.length) {
            [SCLogger log:[NSString stringWithFormat:@"Response data: %@",
                           [NSString stringWithUTF8String:data.bytes]]];
        }
        if (error) {
            [SCLogger log:[NSString stringWithFormat:@"Response error: %@",
                           error.description]];
        }
    }
#endif
}

@end
