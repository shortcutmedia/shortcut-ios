//
//  SCLinkIDExtractor.m
//  Shortcut
//
//  Created by Severin Schoepke on 24/09/15.
//  Copyright © 2015 Shortcut Media AG. All rights reserved.
//

#import "SCLinkIDExtractor.h"

NSString *kSCLinkIDParamString = @"sc_link_id";

@implementation SCLinkIDExtractor

- (NSString *)linkIDFromURL:(NSURL *)url {
    NSString *linkId = nil;
    
    for (NSString *keyValueString in [url.query componentsSeparatedByString:@"&"]) {
        NSArray *keyValue = [keyValueString componentsSeparatedByString:@"="];
        if ([[keyValue firstObject] isEqualToString:kSCLinkIDParamString]) {
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
        if (![[keyValue firstObject] isEqualToString:kSCLinkIDParamString]) {
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
