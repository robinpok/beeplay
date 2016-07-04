//
//  MJBeepMapViewController.h
//  Beeplay
//
//  Created by Saül Baró on 10/14/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MapKit;

@class MJBeepAnnotation;

@interface MJBeepMapViewController : UIViewController

@property (strong, nonatomic) MJBeepAnnotation *beepAnnotation;
@property (strong, nonatomic) MKMapItem *locationItem;
@property (strong, nonatomic) NSString *locationAddress;

@end
