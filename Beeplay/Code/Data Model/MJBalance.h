//
//  MJBalance.h
//  Beeplay
//
//  Created by Saül Baró on 10/11/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@class MJUser;
@class MJBeep;

#import <Parse/Parse.h>

@interface MJBalance : PFObject <PFSubclassing>

@property (strong, nonatomic) NSDecimalNumber *accountBalance;
@property (strong, nonatomic) NSDecimalNumber *pointsBalance;
@property (strong, nonatomic) NSDecimalNumber *accumulatedMoneyBalance;
@property (strong, nonatomic) NSDecimalNumber *accumulatedPointsBalance;

@end