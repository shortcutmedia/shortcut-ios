//
//  SCJSONRequest.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCJSONRequest.h"

#import "SCDeviceFingerprint.h"

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
        
        [self logResponse:response data:data error:error];
        
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
    NSLog(@"Sending request %@ %@ with data %@", request.HTTPMethod, request.URL, [NSString stringWithUTF8String:request.HTTPBody.bytes]);
#endif
}

- (void)logResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error {
#ifdef DEBUG
    long statusCode = -1;
    if ([response isKindOfClass:NSHTTPURLResponse.class]) {
        statusCode = ((NSHTTPURLResponse *)response).statusCode;
    }
    
    if (!error) {
        NSLog(@"Received response with code %ld and data %@", statusCode, [NSString stringWithUTF8String:data.bytes]);
    } else {
        NSLog(@"Received response with code %ld and error %@", statusCode, error.description);
    }
#endif
}

@end
