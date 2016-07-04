//
//  NSError+ParseError.m
//  Beeplay
//
//  Created by Saül Baró on 10/7/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "NSError+ParseError.h"

#import <Parse/PFConstants.h>

@implementation NSError (ParseError)

- (NSString *)parse_errorDescription
{
    NSString *errorMessage = nil;
    if (!(errorMessage = self.parseErrorMessages[@(self.code)])) {
        errorMessage = NSLocalizedString(@"Se ha producido un error.", nil);
    }
    return errorMessage;
}

static NSDictionary *_parseErrorMessages;

- (NSDictionary *)parseErrorMessages
{
    if (!_parseErrorMessages) {
        _parseErrorMessages = @{
                                @(kPFErrorObjectNotFound) : NSLocalizedString(@"El usuario y/o la contraseña introducidos no son válidos.", nil),
                                @(kPFErrorConnectionFailed) : NSLocalizedString(@"La conexión a Internet parece estar desactivada.", nil),
                                @(kPFErrorUsernameTaken) : NSLocalizedString(@"Ya existe una cuenta con esta dirección de correo.", nil),
                                @(kPFErrorInvalidEmailAddress) : NSLocalizedString(@"La dirección de correo no es válida.", nil),
                                @(kPFErrorUserEmailMissing) : NSLocalizedString(@"Debe introducir una dirección de correo.", nil),
                                @(kPFErrorUserWithEmailNotFound) : NSLocalizedString(@"No existe ningún usuario con esta dirección de correo.", nil)
                                };
    }
    return _parseErrorMessages;
}

@end
