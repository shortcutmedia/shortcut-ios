//
//  SCDeepLinking.m
//  Shortcut
//
//  Created by Severin Schoepke on 18/09/15.
//  Copyright (c) 2015 Shortcut Media AG. All rights reserved.
//

#import "SCDeepLinking.h"

#import <UIKit/UIKit.h>
#import "SCConfig.h"
#import "SCLogger.h"
#import "SCShortLink.h"
#import "SCDeepLinkOpener.h"
#import "SCFirstLaunchChecker.h"

@interface SCDeepLinking ()

@property (strong, nonatomic) SCSession *currentSession;

@end


@implementation SCDeepLinking

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopCurrentSession)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


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
    BOOL firstLaunch = [[SCFirstLaunchChecker sharedInstance] isFirstLaunch];
    if (!firstLaunch) {
        [SCLogger log:@"Doing no deferred deep link lookup since app is not freshly installed"];
        return;
    }
    
    [SCLogger log:@"Doing deferred deep link lookup"];
    [SCSession firstLaunchLookupWithCompletionHandler:^(SCSession *session) {
        self.currentSession = session;
        
        if (self.currentSession) {
            [SCLogger log:[NSString stringWithFormat:@"Found deferred deep link: %@",
                           self.currentSession.url.absoluteString]];
            SCDeepLinkOpener *deepLinkOpener = [[SCDeepLinkOpener alloc] init];
            [deepLinkOpener openURL:self.currentSession.url];
        } else {
            [SCLogger log:@"Found no deferred deep link"];
        }
    }];
}


- (SCSession *)startSessionWithURL:(NSURL *)url {
    
    // Stop current session if the URL changed
    if (self.currentSession && ![self.currentSession.url isEqual:url]) {
        [self.currentSession finish];
        self.currentSession = nil;
    }
    
    // Start a new current session if necessary
    if (!self.currentSession) {
        self.currentSession = [[SCSession alloc] initWithURL:url];
        [self.currentSession start];
    }
    
    [SCLogger log:[NSString stringWithFormat:@"Starting session for deep link: %@",
                   [self.currentSession.url absoluteString]]];
    
    return self.currentSession;
}


- (void)stopCurrentSession {
    if (self.currentSession) {
        [self.currentSession finish];
        self.currentSession = nil;
    }
}


- (void)createShortLinkWithWebsiteURL:(NSURL *)websiteURL
                    completionHandler:(void (^)(NSURL *, NSError *))completionHandler {
    [self createShortLinkWithTitle:nil
                        websiteURL:websiteURL
                 completionHandler:completionHandler];
}

- (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
               completionHandler:(void (^)(NSURL *, NSError *))completionHandler {
    [self createShortLinkWithTitle:title
                        websiteURL:websiteURL
                       deepLinkURL:nil
                 completionHandler:completionHandler];
}

- (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                     deepLinkURL:(NSURL *)deepLinkURL
               completionHandler:(void (^)(NSURL *, NSError *))completionHandler {
    [self createShortLinkWithTitle:title
                        websiteURL:websiteURL
                    iOSDeepLinkURL:deepLinkURL
                androidDeepLinkURL:deepLinkURL
           windowsPhoneDeepLinkURL:deepLinkURL
                 completionHandler:completionHandler];
}

- (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                  iOSDeepLinkURL:(NSURL *)iOSDeepLinkURL
              androidDeepLinkURL:(NSURL *)androidDeepLinkURL
         windowsPhoneDeepLinkURL:(NSURL *)windowsPhoneDeepLinkURL
               completionHandler:(void (^)(NSURL *, NSError *))completionHandler {
    [self createShortLinkWithTitle:title
                        websiteURL:websiteURL
                    iOSAppStoreURL:nil
                    iOSDeepLinkURL:iOSDeepLinkURL
                androidAppStoreURL:nil
                androidDeepLinkURL:androidDeepLinkURL
           windowsPhoneAppStoreURL:nil
           windowsPhoneDeepLinkURL:windowsPhoneDeepLinkURL
                 completionHandler:completionHandler];
}

- (void)createShortLinkWithTitle:(NSString *)title
                      websiteURL:(NSURL *)websiteURL
                  iOSAppStoreURL:(NSURL *)iOSAppStoreURL
                  iOSDeepLinkURL:(NSURL *)iOSDeepLinkURL
              androidAppStoreURL:(NSURL *)androidAppStoreURL
              androidDeepLinkURL:(NSURL *)androidDeepLinkURL
         windowsPhoneAppStoreURL:(NSURL *)windowsPhoneAppStoreURL
         windowsPhoneDeepLinkURL:(NSURL *)windowsPhoneDeepLinkURL
               completionHandler:(void (^)(NSURL *, NSError *))completionHandler {
    
    SCShortLink *shortLink = [[SCShortLink alloc] initWithTitle:title
                                                     websiteURL:websiteURL
                                                 iOSAppStoreURL:iOSAppStoreURL
                                                 iOSDeepLinkURL:iOSDeepLinkURL
                                             androidAppStoreURL:androidAppStoreURL
                                             androidDeepLinkURL:androidDeepLinkURL
                                        windowsPhoneAppStoreURL:windowsPhoneAppStoreURL
                                        windowsPhoneDeepLinkURL:windowsPhoneDeepLinkURL];
    
    NSOperationQueue *completionHandlerQueue = [NSOperationQueue currentQueue];
    if (!completionHandlerQueue) {
        completionHandlerQueue = [NSOperationQueue mainQueue];
    }
    
    [shortLink createWithCompletionHandler:^(NSError *error) {
        [completionHandlerQueue addOperationWithBlock:^{
            completionHandler(shortLink.shortURL, error);
        }];
    }];
}

@end

