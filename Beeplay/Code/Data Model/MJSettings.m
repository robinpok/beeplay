//
//  MJSettings.m
//  Beeplay
//
//  Created by Saül Baró on 14/01/2014.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJSettings.h"
#import <Parse/PFObject+Subclass.h>

@implementation MJSettings

#pragma mark - Properties

@dynamic minimumMoneyBalanceToReclaim;
@dynamic minimumPointsBalanceToReclaim;

#pragma mark - Super class method overriding

/*! The name of the class as seen in the REST API. */
+ (NSString *)parseClassName
{
    return @"Settings";
}

@end
