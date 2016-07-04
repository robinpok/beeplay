//
//  MJBeep.h
//  Beeplay
//
//  Created by Saül Baró Ruiz on 26/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import Foundation;
@import CoreLocation;

#import <Parse/Parse.h>

typedef NS_ENUM(NSUInteger, MJBeepStatus) {
    MJBeepStatusNoUsers = 0,
    MJBeepStatusWithUsers,
    MJBeepStatusWithFeedback,
    MJBeepStatusCompleted
};

@interface MJBeep : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDecimalNumber *price;
@property (strong, nonatomic) NSDecimalNumber *points;
@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *addressLine1;
@property (strong, nonatomic) NSString *addressLine2;

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;

@property (strong, nonatomic) NSString *beepDescription;
@property (strong, nonatomic) NSString *responseEmail;
@property (nonatomic) MJBeepStatus status;
@property (nonatomic) BOOL geolocationRequired;
@property (nonatomic) BOOL photoRequired;
@property (nonatomic) BOOL cameraRollAllowed;
@property (nonatomic) BOOL visibility;

- (CLLocation *)location;

@end
