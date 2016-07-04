//
//  MJValidator.m
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJValidator.h"

@interface MJValidator ()

@property (strong, nonatomic) NSRegularExpression *emailRegEx;

@end

@implementation MJValidator

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static MJValidator *sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[MJValidator alloc] init];
    });
    return sharedObject;
}

- (NSRegularExpression *)emailRegEx
{
    if (!_emailRegEx) {
        // Based on RFC 5322 - http://www.regular-expressions.info/email.html
        static NSString *emailRegExPattern = @"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\\])";
        
        
        _emailRegEx = [[NSRegularExpression alloc] initWithPattern:emailRegExPattern
                                                           options:NSRegularExpressionCaseInsensitive
                                                             error:nil];
    }
    
    return _emailRegEx;
}

- (BOOL)validateEmail:(NSString *)emailAddress
{
    NSUInteger regExMatches = [self.emailRegEx numberOfMatchesInString:emailAddress
                                                               options:0
                                                                 range:NSMakeRange(0, [emailAddress length])];
    return !regExMatches;
}

@end
