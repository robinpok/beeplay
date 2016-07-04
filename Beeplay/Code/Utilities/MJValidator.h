//
//  MJValidator.h
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import Foundation;
@interface MJValidator : NSObject

- (BOOL)validateEmail:(NSString *)emailAddress;

+ (instancetype)sharedInstance;

@end
