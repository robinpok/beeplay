//
//  MJBeepFeedbackViewController.h
//  Beeplay
//
//  Created by Saül Baró on 10/16/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;
#import <CoreLocation/CoreLocation.h>
@class MJBeep, MJBeepSubscription;

@interface MJBeepFeedbackViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) MJBeep *beep;
@property (strong, nonatomic) MJBeepSubscription *beepSubscription;

@end
