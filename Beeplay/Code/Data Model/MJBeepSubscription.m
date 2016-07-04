//
//  MJBeepSubscription.m
//  Beeplay
//
//  Created by Saül Baró on 10/7/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJBeepSubscription.h"

#import <Parse/PFObject+Subclass.h>

@implementation MJBeepSubscription

#pragma mark - Properties

@dynamic beep;
@dynamic user;
@dynamic status;

#pragma mark - Super class method overriding

/*! The name of the class as seen in the REST API. */
+ (NSString *)parseClassName
{
    return @"BeepSubscription";
}

@end
