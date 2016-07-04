//
//  NSError+ParseError.h
//  Beeplay
//
//  Created by Saül Baró on 10/7/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ParseError)

- (NSString *)parse_errorDescription;

@end
