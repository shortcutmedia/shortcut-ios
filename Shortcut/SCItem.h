//
//  SCItem.h
//  Shortcut
//
//  Created by Severin Schoepke on 13/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCItem : NSObject


@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSURL *websiteURL;

@property (strong, nonatomic, readonly) NSURL *iOSAppStoreURL;
@property (strong, nonatomic, readonly) NSURL *iOSDeepLinkURL;

@property (strong, nonatomic, readonly) NSURL *androidAppStoreURL;
@property (strong, nonatomic, readonly) NSURL *androidDeepLinkURL;

@property (strong, nonatomic, readonly) NSURL *shortURL;
@property (strong, nonatomic, readonly) NSString *UUID;

- (instancetype)initWithTitle:(NSString *)title
                   websiteURL:(NSURL *)websiteURL
               iOSAppStoreURL:(NSURL *)iOSAppStoreURL
               iOSDeepLinkURL:(NSURL *)iOSDeepLinkURL
           androidAppStoreURL:(NSURL *)androidAppStoreURL
           androidDeepLinkURL:(NSURL *)androidDeepLinkURL
      windowsPhoneAppStoreURL:(NSURL *)windowsPhoneAppStoreURL
      windowsPhoneDeepLinkURL:(NSURL *)windowsPhoneDeepLinkURL;

/**
 *  Creates the item on the Shortcut Backend.
 *
 *  This method attempts to create the item on the Shortcut Backend. When the operation has
 *  completed, it calls the completion handler.
 *  If the item was successfully created then its UUID and shortURL properties will be set.
 *  If the creation failed then the completion handler receives an error object with the 
 *  kSCItemErrorDomain describing the error.
 *
 *  @param completionHandler A handler that will be called after the operation is completed.
 */
- (void)createWithCompletionHandler:(void (^)(NSError *error))completionHandler;


/**
 *  Item error domain.
 */
extern NSString *kSCItemErrorDomain;

@end
