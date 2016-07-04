//
//  MJBeepSubscription.h
//  Beeplay
//
//  Created by Saül Baró on 10/7/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@class MJUser;
@class MJBeep;

#import <Parse/Parse.h>

typedef NS_ENUM(NSUInteger, MJBeepSubscriptionStatus) {
    MJBeepSubscriptionStatusSubscribed = 0,
    MJBeepSubscriptionStatusFeedbackSent,
    MJBeepSubscriptionStatusFeedbackApproved,
    MJBeepSubscriptionStatusFeedbackDeclined,
    MJBeepSubscriptionStatusTimedOut
};

@interface MJBeepSubscription : PFObject <PFSubclassing>

@property (strong, nonatomic) MJBeep *beep;
@property (strong, nonatomic) MJUser *user;
@property (nonatomic) MJBeepSubscriptionStatus status;

@end
