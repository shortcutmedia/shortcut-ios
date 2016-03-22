//
//  SCShortLink.h
//  Shortcut
//
//  Created by Severin Schoepke on 13/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCShortLink : NSObject


@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSURL *websiteURL;

@property (strong, nonatomic, readonly) NSURL *iOSDeepLinkURL;
@property (strong, nonatomic, readonly) NSURL *androidDeepLinkURL;
@property (strong, nonatomic, readonly) NSURL *windowsPhoneDeepLinkURL;

@property (strong, nonatomic, readonly) NSURL *shortURL;

- (instancetype)initWithTitle:(NSString *)title
                   websiteURL:(NSURL *)websiteURL
               iOSDeepLinkURL:(NSURL *)iOSDeepLinkURL
           androidDeepLinkURL:(NSURL *)androidDeepLinkURL
      windowsPhoneDeepLinkURL:(NSURL *)windowsPhoneDeepLinkURL;

/**
 *  Creates the short link on the Shortcut Backend.
 *
 *  This method attempts to create the short link on the Shortcut Backend. When the operation has
 *  completed, it calls the completion handler.
 *  If the short link was successfully created then its shortURL property will be set.
 *  If the creation failed then the completion handler receives an error object with the 
 *  kSCShortLinkErrorDomain describing the error.
 *
 *  @param completionHandler A handler that will be called after the operation is completed.
 */
- (void)createWithCompletionHandler:(void (^)(NSError *error))completionHandler;


/**
 *  Short link error domain.
 */
extern NSString *kSCShortLinkErrorDomain;

@end
