//
//  MJBeepsViewController.h
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;
@import MapKit;

extern NSString * const BeepsViewControllerReloadDataNotification;

@interface MJBeepsViewController : UITableViewController
{
    CLLocation *location;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
