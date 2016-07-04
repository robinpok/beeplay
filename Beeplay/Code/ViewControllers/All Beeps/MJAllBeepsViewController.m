//
//  MJAllBeepsViewController.m
//  Beeplay
//
//  Created by Saül Baró on 9/27/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJAllBeepsViewController.h"

#import "MJController.h"
#import "MJBeep.h"

#import "UIViewController+PerformTaskWithProgress.h"
#import "UIViewController+AlertMessages.h"
#import "NSError+BeeplayError.h"

@class MJBeep;

typedef NS_ENUM(NSUInteger, MJBeepsOrder) {
    MJBeepsOrderByPrice = 0,
    MJBeepsOrderByDistance
};

@interface MJAllBeepsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegmentedControl;
@property (nonatomic) MJBeepsOrder orderBy;

@property (nonatomic, strong) NSArray *availableBeepsOrderedByPrice;
@property (nonatomic, strong) NSArray *availableBeepsOrderedByLocation;

@end

@implementation MJAllBeepsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self
                            action:@selector(fetchBeeps:)
                  forControlEvents:UIControlEventValueChanged];
    [self reloadData];
}

- (void)reloadData
{
    [self fetchBeeps:nil];
}

#pragma mark - Fetch beeps

- (void)fetchBeeps:(UIRefreshControl *)control
{
    BOOL showProgress = !control;
    if (!showProgress) {
        [self.refreshControl beginRefreshing];
    }
    __block NSArray *availableBeeps;
    [self performTask:^(NSError *__autoreleasing *error) {
        availableBeeps = [[MJController sharedInstance] availableBeeps:error];
    }
         withProgress:showProgress
    completionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self displayErrorMessage:[error beeplay_errorDescription]];
            }
            else {
                if (!showProgress) {
                    [self.refreshControl endRefreshing];
                }
                if ([availableBeeps count] == 0) {
                    [self displayWarningMessage:NSLocalizedString(@"Todos los Beeps ya están asignados, vuelve a pasarte por aquí más tarde.", nil)];
                }
                self.availableBeepsOrderedByPrice = availableBeeps;
                self.availableBeepsOrderedByLocation = nil;
                [self.tableView reloadData];
            }
        });
    }];
}

#pragma mark - Filter

- (NSArray *)availableBeepsOrderedByLocation
{
    if (!_availableBeepsOrderedByLocation) {
        _availableBeepsOrderedByLocation = [self.availableBeepsOrderedByPrice sortedArrayUsingComparator:^NSComparisonResult(MJBeep *beep1, MJBeep *beep2) {
            CLLocationDistance distanceToBeep1 = [location distanceFromLocation:[beep1 location]];
            CLLocationDistance distanceToBeep2 = [location distanceFromLocation:[beep2 location]];
            return [@(distanceToBeep1) compare:@(distanceToBeep2)];
        }];
    }
    return _availableBeepsOrderedByLocation;
}

- (NSArray *)availableBeeps
{
    NSArray *availableBeeps;
    switch (self.orderBy) {
        case MJBeepsOrderByPrice:
            availableBeeps = self.availableBeepsOrderedByPrice;
            break;
        case MJBeepsOrderByDistance:
            availableBeeps = self.availableBeepsOrderedByLocation;
            break;
    }
    return availableBeeps;
}

- (IBAction)changeFilter:(UISegmentedControl *)sender
{
    self.orderBy = sender.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (IBAction)dismissListView:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)setupUI
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.filterSegmentedControl.hidden = YES;
        self.orderBy = MJBeepsOrderByPrice;
    }
    else {
        self.filterSegmentedControl.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - Abstract methods

- (NSUInteger)numberOfSections
{
    // Return the number of sections.
    return 1;
}

- (NSUInteger)numberOfCellsForSection:(NSUInteger)section
{
    return [self.availableBeeps count];
}

- (MJBeep *)beepForIndexPath:(NSIndexPath *)indexPath
{
    return self.availableBeeps[indexPath.item];
}

- (NSString *)titleForSection:(NSUInteger)section
{
    return nil;
};

- (void)reloadDataForLocationChange
{
    self.availableBeepsOrderedByLocation = nil;
    [self.tableView reloadData];
};

@end
