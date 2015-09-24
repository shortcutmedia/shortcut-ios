//
//  ShortcutDeepLinkingSDK.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import "SCDeepLinking.h"

#import <UIKit/UIKit.h>
#import "SCDeviceFingerprint.h"

NSString * const kFirstOpenURLString = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/first_open";
NSString * const kOpenURLString      = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/open";
NSString * const kLinkIDParamString  = @"sc_link_id";
NSString * const kAlreadyLaunchedKey = @"sc.shortcut.AlreadyLaunched";

@interface SCDeepLinking ()

@property (strong, nonatomic) NSOperationQueue *httpQueue;

@end


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


#pragma mark - Properties

- (NSOperationQueue *)httpQueue {
    if (!_httpQueue) {
        _httpQueue = [[NSOperationQueue alloc] init];
    }
    return _httpQueue;
}


#pragma mark - Interactions

- (void)launch {
    BOOL firstLaunch = [self checkForFirstLaunch];
    if (!firstLaunch) {
        return;
    }
    
    [self JSONPOSTRequestToURL:[NSURL URLWithString:kFirstOpenURLString] params:nil completionHandler:^(NSURLResponse *response, NSDictionary *content, NSError *error) {
        if (error) {
            NSLog(@"error: %@", [error description]);
        } else {
            NSString *deepLinkURIString = nil;
            if ([content[@"uri"] isKindOfClass:NSString.class]) {
                deepLinkURIString = content[@"uri"];
                
                NSURL *deepLinkURL = [self URLWithoutLinkID:[NSURL URLWithString:deepLinkURIString]];
                if ([deepLinkURL absoluteString].length) {
                    [[UIApplication sharedApplication] openURL:deepLinkURL];
                }
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
        
    return [self URLWithoutLinkID:url];
}


#pragma mark - Helpers

- (BOOL)checkForFirstLaunch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL alreadyLaunched = [defaults boolForKey:kAlreadyLaunchedKey];
    if (!alreadyLaunched) {
        [defaults setBool:YES forKey:kAlreadyLaunchedKey];
        [defaults synchronize];
    }
    
    return !alreadyLaunched;
}


- (void)JSONPOSTRequestToURL:(NSURL *)url params:(NSDictionary *)params completionHandler:(void (^)(NSURLResponse *response, NSDictionary *content, NSError *error))completionHandler {
    
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
    
    // Send request
    [NSURLConnection sendAsynchronousRequest:request queue:[self httpQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
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


- (NSURL *)URLWithoutLinkID:(NSURL *)url {
    NSString *baseURLString = [[url.absoluteString componentsSeparatedByString:@"?"] firstObject];
    
    NSMutableString *newQueryString = [[NSMutableString alloc] init];
    for (NSString *keyValueString in [url.query componentsSeparatedByString:@"&"]) {
        NSArray *keyValue = [keyValueString componentsSeparatedByString:@"="];
        if (![[keyValue firstObject] isEqualToString:kLinkIDParamString]) {
            [newQueryString appendFormat:@"%@=%@", [keyValue firstObject], [keyValue lastObject]];
        }
    }
    
    NSString *newURLString = baseURLString;
    if (newQueryString.length) {
        newURLString = [newURLString stringByAppendingFormat:@"?%@", newQueryString];
    }
    
    return [NSURL URLWithString:newURLString];
}

@end

