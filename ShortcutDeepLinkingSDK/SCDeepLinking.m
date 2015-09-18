//
//  ShortcutDeepLinkingSDK.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import "SCDeepLinking.h"
#import <UIKit/UIKit.h>

NSString * const kFirstOpenURLString = @"http://192.168.178.67:3001/api/v1/deep_links/first_open";
NSString * const kOpenURLString      = @"http://192.168.178.67:3001/api/v1/deep_links/open";
NSString * const kLinkIDParamString  = @"sc_link_id";


@implementation SCDeepLinking


#pragma mark - Singleton instance

+ (instancetype)sharedInstance {
    static SCDeepLinking* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


#pragma mark - Interactions

- (void)launch {
    
    [self JSONPOSTRequestToURL:[NSURL URLWithString:kFirstOpenURLString] params:nil completionHandler:^(NSURLResponse *response, NSDictionary *content, NSError *error) {
        if (error) {
            NSLog(@"error: %@", [error description]);
        } else {
            NSString *deepLinkURI = content[@"uri"];
            if (deepLinkURI) {
                NSLog(@"opening deep link: %@", deepLinkURI);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:deepLinkURI]];
            }
        }
    }];
}


- (NSURL *)handleOpenURL:(NSURL *)url {
    NSString *linkId = [self extractLinkIDFromURL:url];
    
    if (linkId) {
        [self JSONPOSTRequestToURL:[NSURL URLWithString:kOpenURLString] params:@{kLinkIDParamString : linkId} completionHandler:^(NSURLResponse *response, NSDictionary *content, NSError *error) {
            if (error) {
                NSLog(@"error: %@", [error description]);
            }
        }];
    }
    
    return url;
}


#pragma mark - Helpers

- (void)JSONPOSTRequestToURL:(NSURL *)url params:(NSDictionary *)params completionHandler:(void (^)(NSURLResponse *response, NSDictionary *content, NSError *error))completionHandler {
    
    // Build JSON request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL        = url;
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (params) {
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    }
    
    // Send request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // Handle response
        NSDictionary *content = nil;
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if ([json isKindOfClass:NSDictionary.class]) {
                content = (NSDictionary *)json;
            }
        }
        
        completionHandler(response, content, error);
    }];
}


- (NSString *)extractLinkIDFromURL:(NSURL *)url {
    NSString *linkId = nil;
    
    for (NSString *keyValueString in [url.query componentsSeparatedByString:@"&"]) {
        NSArray *keyValue = [keyValueString componentsSeparatedByString:@"="];
        if ([[keyValue firstObject] isEqualToString:kLinkIDParamString]) {
            linkId = [keyValue lastObject];
            break;
        }
    }
    
    return linkId;
}

@end

