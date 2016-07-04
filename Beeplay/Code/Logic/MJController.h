//
//  MJController.h
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@class MJUser;
@class MJBeep;
@class MJBeepSubscription;
@class MJSettings;

@interface MJController : NSObject

// User management
- (MJUser *)currentUser;
- (NSError *)createUser:(MJUser *)newUser;
- (NSError *)updateUser:(MJUser *)user;
- (NSError *)logInWithUsername:(NSString *)username password:(NSString *)password;
- (void)logOutCurrentUser;
- (NSError *)passwordResetForEmail:(NSString *)emailAddress;

// Beep management
- (NSArray *)availableBeeps:(NSError **)error;
- (NSDictionary *)mySubscriptionsGroupedByStatus:(NSError **)error;
- (MJBeepSubscription *)createSubscriptionForBeep:(MJBeep *)beep error:(NSError **)error;
- (NSError *)updateSubscription:(MJBeepSubscription *)subscription;
- (MJBeepSubscription *)fetchSubsriptionForBeep:(MJBeep *)beep error:(NSError **)error;
+ (MJController *)sharedInstance;

// Balance management
- (NSError *)refreshBalance;
- (MJSettings *)settings;
- (NSError *)reclaimBalance:(NSString *)amount;


// Feedback management
- (NSError *)sendFeedback:(NSString *)text withImages:(NSArray *)images forBeep:(MJBeep *)beep;

@end
