//
//  SCSession.m
//  Shortcut
//
//  Created by Severin Schoepke on 25/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCSession.h"
#import "SCLinkIDExtractor.h"
#import "SCJSONRequest.h"

NSString * const kSCSessionFirstOpenURLString = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/first_open";
NSString * const kSCSessionOpenURLString      = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/open";
NSString * const kSCSessionCloseURLString     = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/close";

NSString * const kSCSessionIDParamString = @"session_id";

@interface SCSession ()

@property (strong, nonatomic, readwrite) NSURL *url;
@property (strong, nonatomic, readwrite) NSString *linkID;
@property (strong, nonatomic, readwrite) NSString *sessionID;

@end

@implementation SCSession

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.sessionID = [[self class] generateSessionID];
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

- (instancetype)initWithSessionID:(NSString *)sessionID URL:(NSURL *)url {
    
    self = [self initWithURL:url];
    
    if (self) {
        self.sessionID = sessionID;
    }
    
    return self;
}

+ (void)firstLaunchLookupWithCompletionHandler:(void (^)(SCSession *session))completionHandler {
    
    NSString *sessionID = [self generateSessionID];
    
    [SCJSONRequest postToURL:[NSURL URLWithString:kSCSessionFirstOpenURLString]
                      params:@{kSCSessionIDParamString : sessionID}
           completionHandler:^(NSURLResponse *response, NSDictionary *content, NSError *error) {
        
               SCSession *session = nil;
               
               if (!error) {
                   if ([content[@"uri"] isKindOfClass:NSString.class]) {
                       NSURL *deepLinkURL = [NSURL URLWithString:content[@"uri"]];
                       session = [[self alloc] initWithSessionID:sessionID URL:deepLinkURL];
                   }
               }
               completionHandler(session);
    }];
}

- (void)start {
    
    if (self.linkID) {
        [SCJSONRequest postToURL:[NSURL URLWithString:kSCSessionOpenURLString]
                          params:[self paramsDictionary]
               completionHandler:nil];
    }
}

- (void)finish {
    
    if (self.linkID) {
        [SCJSONRequest postToURL:[NSURL URLWithString:kSCSessionCloseURLString]
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
    
    if (self.linkID)    { params[kSCLinkIDParamString] = self.linkID; }
    if (self.sessionID) { params[kSCSessionIDParamString] = self.sessionID; }

    return params;
}

+ (NSString *)generateSessionID {
    return [[NSUUID UUID] UUIDString];
}

@end
