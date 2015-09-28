//
//  SCSession.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 25/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCSession.h"
#import "SCLinkIDExtractor.h"
#import "SCJSONRequest.h"

NSString * const kFirstOpenURLString = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/first_open";
NSString * const kOpenURLString      = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/open";
NSString * const kCloseURLString     = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/close";

NSString * const kSessionIDParamString = @"session_id";

@interface SCSession ()

@property (strong, nonatomic, readwrite) NSURL *url;
@property (strong, nonatomic, readwrite) NSString *linkID;
@property (strong, nonatomic, readwrite) NSString *sessionID;

@end

@implementation SCSession

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.sessionID = [[NSUUID UUID] UUIDString];
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    
    self = [self init];
    
    if (self) {
        [self updateWithURL:url];
    }
    
    return self;
}

- (void)firstLaunchLookupWithCompletionHandler:(void (^)())completionHandler {
    
    [SCJSONRequest postToURL:[NSURL URLWithString:kFirstOpenURLString]
                      params:[self paramsDictionary]
           completionHandler:^(NSURLResponse *response, NSDictionary *content, NSError *error) {
        if (!error) {
            if ([content[@"uri"] isKindOfClass:NSString.class]) {
                NSURL *deepLinkURL = [NSURL URLWithString:content[@"uri"]];
                [self updateWithURL:deepLinkURL];
                completionHandler();
            }
        }
    }];
}

- (void)start {
    
    if (self.linkID) {
        [SCJSONRequest postToURL:[NSURL URLWithString:kOpenURLString]
                          params:[self paramsDictionary]
               completionHandler:nil];
    }
}

- (void)finish {
    
    if (self.linkID) {
        [SCJSONRequest postToURL:[NSURL URLWithString:kCloseURLString]
                          params:[self paramsDictionary]
               completionHandler:nil];
    }
}

#pragma mark - Helpers

- (void)updateWithURL:(NSURL *)url {
    SCLinkIDExtractor *linkIDExtractor = [[SCLinkIDExtractor alloc] init];
    
    self.linkID = [linkIDExtractor linkIDFromURL:url];
    self.url    = [linkIDExtractor URLWithoutLinkID:url];
}

- (NSDictionary *)paramsDictionary {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.linkID)    { params[kLinkIDParamString] = self.linkID; }
    if (self.sessionID) { params[kSessionIDParamString] = self.sessionID; }

    return params;
}

@end
