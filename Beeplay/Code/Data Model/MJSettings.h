//
//  MJSettings.h
//  Beeplay
//
//  Created by Saül Baró on 14/01/2014.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <Parse/Parse.h>

@interface MJSettings : PFObject <PFSubclassing>

@property (strong, nonatomic) NSDecimalNumber *minimumMoneyBalanceToReclaim;
@property (strong, nonatomic) NSDecimalNumber *minimumPointsBalanceToReclaim;

@end
