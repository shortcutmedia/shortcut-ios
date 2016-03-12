//
//  SCConfig.h
//  Shortcut
//
//  Created by Severin Schoepke on 13/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCConfig : NSObject

/**
 *  The token used for authentication with the Shortcut backend.
 *  
 *  An API key with a token can be generated in the Shortcut Manager.
 */
@property (strong, nonatomic) NSString *authToken;

/**
 *  By default the some debug information is logged. Use this property to turn off this logging.
 */
@property (nonatomic) BOOL loggingEnabled;


/// @name Accessing the global instance

/**
 *  This class is a singleton. You cannot instantiate new instances.
 *  Use the SCConfig +sharedConfig method to get the singleton instance.
 */
- (instancetype)init __attribute__((unavailable("use SCConfig +sharedConfig")));

/**
 *  Returns the singleton instance.
 *
 *  @return The global config instance.
 */
+ (instancetype)sharedConfig;

@end
