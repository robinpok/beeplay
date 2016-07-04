//
//  MJBalance.m
//  Beeplay
//
//  Created by Saül Baró on 10/11/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJBalance.h"

#import <Parse/PFObject+Subclass.h>

@implementation MJBalance

#pragma mark - Properties

@dynamic accountBalance;
@dynamic pointsBalance;
@dynamic accumulatedMoneyBalance;
@dynamic accumulatedPointsBalance;

#pragma mark - Super class method overriding

/*! The name of the class as seen in the REST API. */
+ (NSString *)parseClassName
{
    return @"Balance";
}

+ (instancetype)object
{
    MJBalance *balance = (MJBalance *)[super object];
    balance.accountBalance = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    balance.pointsBalance = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    balance.accumulatedMoneyBalance = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    balance.accumulatedPointsBalance = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    return balance;
}

@end
