//
//  SCConfig.m
//  Shortcut
//
//  Created by Severin Schoepke on 13/10/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCConfig.h"

#import "SCLogger.h"

NSString * const kSCConfigDefaultShortLinkDomain = @"scm.st";

@implementation SCConfig

+ (instancetype)sharedConfig {
    static SCConfig *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues {
    
    self.loggingEnabled  = YES;
    self.shortLinkDomain = self.defaultShortLinkDomain;
}

- (NSString *)defaultShortLinkDomain {
    return kSCConfigDefaultShortLinkDomain;
}

- (void)setShortLinkDomain:(NSString *)value {
    // Very basic regex to check domain according to RFC-1035 (parts separated by dots, parts may only contain
    // letters, digits and hyphens)
    NSRegularExpression *domainRegEx = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9-\\.]+$"
                                                                                 options:0
                                                                                   error:nil];
    BOOL domainValid = value && [domainRegEx matchesInString:value
                                                     options:0
                                                       range:NSMakeRange(0, value.length)].count > 0;
    
    if (!domainValid) {
        [SCLogger log:[NSString stringWithFormat:@"Not a valid domain: %@", value]];
        return;
    }
    
    _shortLinkDomain = value;
}

@end
