//
//  SCItem.m
//  ShortcutDeepLinkingSDK
//
//  Created by Severin Schoepke on 13/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCItem.h"
#import "SCJSONRequest.h"

NSString * const kCreateURLString = @"https://shortcut-service.shortcutmedia.com/api/v1/deep_links/create";

NSString *kSCItemErrorDomain = @"SCItemErrorDomain";

@interface SCItem ()

@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSURL *websiteURL;

@property (strong, nonatomic, readwrite) NSURL *iOSAppStoreURL;
@property (strong, nonatomic, readwrite) NSURL *iOSDeepLinkURL;

@property (strong, nonatomic, readwrite) NSURL *androidAppStoreURL;
@property (strong, nonatomic, readwrite) NSURL *androidDeepLinkURL;

@property (strong, nonatomic, readwrite) NSURL *shortURL;
@property (strong, nonatomic, readwrite) NSString *UUID;

@end

@implementation SCItem

- (instancetype)initWithTitle:(NSString *)title
                   websiteURL:(NSURL *)websiteURL
               iOSAppStoreURL:(NSURL *)iOSAppStoreURL
               iOSDeepLinkURL:(NSURL *)iOSDeepLinkURL
           androidAppStoreURL:(NSURL *)androidAppStoreURL
           androidDeepLinkURL:(NSURL *)androidDeepLinkURL {
    
    self = [self init];
    
    if (self) {
        self.title      = title;
        self.websiteURL = websiteURL;
        
        self.iOSAppStoreURL = iOSAppStoreURL;
        self.iOSDeepLinkURL = iOSDeepLinkURL;
        
        self.androidAppStoreURL = androidAppStoreURL;
        self.androidDeepLinkURL = androidDeepLinkURL;
    }
    
    return self;
}

- (void)createWithCompletionHandler:(void (^)(NSError *))completionHandler {
    
    
    [SCJSONRequest postToURL:[NSURL URLWithString:kCreateURLString]
                      params:[self paramsDictionary]
           completionHandler:^(NSURLResponse *response, NSDictionary *content, NSError *error) {
               
               NSError *itemCreationError = [self creationErrorFromResponse:response
                                                                    content:content
                                                            connectionError:error];
               
               if (!itemCreationError) {
                   if ([content[@"uuid"] isKindOfClass:NSString.class]) {
                       self.UUID = content[@"uuid"];
                   }
                   if ([content[@"short_url"] isKindOfClass:NSString.class]) {
                       self.shortURL = [NSURL URLWithString:content[@"short_url"]];
                   }
               }
               
               completionHandler(itemCreationError);
    }];
}

#pragma mark - Helpers

- (NSDictionary *)paramsDictionary {
    
    NSMutableDictionary *itemParams = [NSMutableDictionary dictionary];
    
    [itemParams setValue:self.title forKeyPath:@"title"];
    [itemParams setValue:[self.websiteURL absoluteString] forKeyPath:@"uri"];
    [itemParams setValue:[NSMutableDictionary dictionary] forKeyPath:@"mobile_deep_link"];
    [itemParams setValue:[self.iOSAppStoreURL absoluteString] forKeyPath:@"mobile_deep_link.ios_app_store_url"];
    [itemParams setValue:[self.iOSDeepLinkURL absoluteString] forKeyPath:@"mobile_deep_link.ios_in_app_url"];
    [itemParams setValue:[self.androidAppStoreURL absoluteString] forKeyPath:@"mobile_deep_link.android_app_store_url"];
    [itemParams setValue:[self.androidDeepLinkURL absoluteString] forKeyPath:@"mobile_deep_link.android_in_app_url"];
    
    return @{@"deep_link_item" : itemParams};
}


- (NSError *)creationErrorFromResponse:(NSURLResponse *)response
                               content:(NSDictionary *)content
                       connectionError:(NSError *)connectionError {
    
    NSError *creationError = nil;
    
    // 401 => auth token invalid or missing
    if ([connectionError.domain isEqualToString:NSURLErrorDomain] &&
          (connectionError.code == NSURLErrorUserAuthenticationRequired ||
           connectionError.code == NSURLErrorUserCancelledAuthentication)) {
        
        NSInteger statusCode = 401;
              
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:@"Auth token missing or invalid" forKey:NSLocalizedDescriptionKey];
        [userInfo setValue:@"Generate an API key with an auth token in the Shortcut Manager and set it using SCConfig or SCDeepLinking classes" forKey:NSLocalizedRecoverySuggestionErrorKey];
        [userInfo setValue:connectionError forKey:NSUnderlyingErrorKey];
        
        creationError = [NSError errorWithDomain:kSCItemErrorDomain
                                            code:statusCode
                                        userInfo:userInfo];
    }
    // 422 => input data is invalid
    else if ([response isKindOfClass:NSHTTPURLResponse.class] &&
             ((NSHTTPURLResponse *)response).statusCode == 422) {
        
        NSInteger statusCode = 422;
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:@"Item data is invalid" forKey:NSLocalizedDescriptionKey];
        if ([content[@"errors"] isKindOfClass:NSDictionary.class]) {
            NSString *serverErrorMessage = [NSString stringWithFormat:@"The Shortcut Backend reports the following errors: %@", content[@"errors"]];
            [userInfo setValue:serverErrorMessage forKey:NSLocalizedFailureReasonErrorKey];
        }
        
        creationError = [NSError errorWithDomain:kSCItemErrorDomain
                                            code:statusCode
                                        userInfo:userInfo];
    }
    // 4XX/5XX => unknown http error
    else if ([response isKindOfClass:NSHTTPURLResponse.class] &&
             ((NSHTTPURLResponse *)response).statusCode > 399) {
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:[NSString stringWithFormat:@"HTTP error with code %ld", (long)statusCode] forKey:NSLocalizedDescriptionKey];
        [userInfo setValue:@"Please try again. If the problem persists contact support@shortcutmedia.com" forKey:NSLocalizedRecoverySuggestionErrorKey];
        
        creationError = [NSError errorWithDomain:kSCItemErrorDomain
                                            code:statusCode
                                        userInfo:userInfo];
    }
    // connection error
    else if (connectionError) {
        
        NSInteger statusCode = connectionError.code;
        
        NSDictionary *userInfo = @{ NSUnderlyingErrorKey : connectionError };
        
        creationError = [NSError errorWithDomain:kSCItemErrorDomain
                                            code:statusCode
                                        userInfo:userInfo];
    }
    
    return creationError;
}

@end
