//
//  MJBeepsViewController.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJBeepsViewController.h"
#import "MJBeepCell.h"
#import "MJBeepDetailsViewController.h"
#import "MJBeep.h"
#import "MJFormatter.h"

#import "UIViewController+AlertMessages.h"

@interface MJBeepsViewController () <CLLocationManagerDelegate>

@end

static NSString * const kShowBeepDetailsSegueIdentifier = @"showBeepDetails";

NSString * const BeepsViewControllerReloadDataNotification = @"BeepsViewControllerReloadDataNotification";

@implementation MJBeepsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:BeepsViewControllerReloadDataNotification
                                               object:nil];

    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 10;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupLocationFeatures];
    [self displayPendingAlerts];
}

- (void)setupLocationFeatures
{
//    if (!self.locationManager) {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = self;
//        self.locationManager.distanceFilter = 10;
//        [self.locationManager startUpdatingLocation];
//    }
    [self setupUI];
}

- (void)setupUI {} // Abstract method

- (void)reloadData {} // Abstract method

#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self setupLocationFeatures];
    [self reloadDataForLocationChange];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    location = [locations lastObject];
    [self reloadDataForLocationChange];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self numberOfCellsForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BeepCell";
    MJBeepCell *beepCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                           forIndexPath:indexPath];
    
    MJBeep *beep = [self beepForIndexPath:indexPath];
    [self configureCell:beepCell forBeep:beep];
    
    return beepCell;
}

- (void)configureCell:(MJBeepCell *)beepCell forBeep:(MJBeep *)beep
{
    beepCell.amountLabel.text = [[MJFormatter sharedInstance] formatCurrency:beep.price];
    beepCell.titleLabel.text = beep.title;
    beepCell.pointsLabel.text = [[MJFormatter sharedInstance] formatPoints:beep.points];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ) {
        CLLocationDistance distance = [self.locationManager.location distanceFromLocation:beep.location];
        beepCell.distanceLabel.text = [[MJFormatter sharedInstance] formatDistance:distance];
    }
    else {
        beepCell.distanceLabel.text = @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self titleForSection:section];
}

#pragma mark - Abstract methods

- (NSUInteger)numberOfSections { return 1; }; // Abstract method

- (NSUInteger)numberOfCellsForSection:(NSUInteger)section { return 0; } // Abstract method

- (MJBeep *)beepForIndexPath:(NSIndexPath *)indexPath { return nil; } // Abstract method

- (NSString *)titleForSection:(NSUInteger)section { return nil; }; // Abstract method

- (void)reloadDataForLocationChange { }; // Abstract method

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMJBeepCellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.backgroundView.backgroundColor = self.view.tintColor;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[MJBeepCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath
        && [segue.identifier isEqualToString:kShowBeepDetailsSegueIdentifier]) {
        MJBeep *beep = [self beepForIndexPath:indexPath];
        if ([segue.destinationViewController respondsToSelector:@selector(setBeep:)]) {
            [segue.destinationViewController performSelector:@selector(setBeep:)
                                                  withObject:beep];
        }
    }
}

@end
