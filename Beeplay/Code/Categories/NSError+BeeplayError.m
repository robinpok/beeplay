//
//  NSError+BeeplayError.m
//  Beeplay
//
//  Created by Saül Baró on 30/12/2013.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "NSError+BeeplayError.h"
#import "NSError+ParseError.h"

#import <Parse/PFConstants.h>

@implementation NSError (BeeplayError)

- (NSString *)beeplay_errorDescription
{
    NSString *errorDescription;
    if (self.code != kPFValidationError) {
        errorDescription = [self parse_errorDescription];
    }
    else {
        if (!(errorDescription = self.beeplayErrorMessages[self.userInfo[@"error"]])) {
            errorDescription = NSLocalizedString(@"Se ha producido un error.", nil);
        }
    }
    
    return errorDescription;
}

static NSDictionary *_beeplayErrorMessages;

- (NSDictionary *)beeplayErrorMessages
{
    if (!_beeplayErrorMessages) {
        _beeplayErrorMessages = @{
                                  @"BP-0100" : NSLocalizedString(@"El Beep no existe.", nil),
                                  @"BP-1000" : NSLocalizedString(@"El Beep ya no esta disponible. Disculpa las molestias.", nil)
                                };
    }
    return _beeplayErrorMessages;
}

@end
