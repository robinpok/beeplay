//
//  MJMyBeepsViewController.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJMyBeepsViewController.h"

#import "MJController.h"
#import "MJUser.h"
#import "MJBeep.h"
#import "MJBeepSubscription.h"

#import "UIViewController+PerformTaskWithProgress.h"
#import "UIViewController+AlertMessages.h"
#import "NSError+BeeplayError.h"

@interface MJMyBeepsViewController ()

@property (strong, nonatomic) NSDictionary *myBeepSubscriptions;

@end

typedef NS_ENUM(NSUInteger, MJMyBeepsSection) {
    MJMyBeepsSectionSubscribed = 0,
    MJMyBeepsSectionFeedbackSent,
    MJMyBeepsSectionFeedbackDeclined,
    MJMyBeepsSectionFeedbackApproved
};

@implementation MJMyBeepsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self
                            action:@selector(fetchMyBeepSubscriptions:)
                  forControlEvents:UIControlEventValueChanged];
    [self reloadData];
}

- (void)reloadData
{
    [self fetchMyBeepSubscriptions:nil];
}

#pragma mark - Fetch beeps

- (void)fetchMyBeepSubscriptions:(UIRefreshControl *)control
{
    BOOL showProgress = !control;
    if (!showProgress) {
        [self.refreshControl beginRefreshing];
    }
    __block NSDictionary *myBeepSubscriptions;
    [self performTask:^(NSError *__autoreleasing *error) {
        myBeepSubscriptions = [[MJController sharedInstance] mySubscriptionsGroupedByStatus:error];
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
                if ([myBeepSubscriptions count] == 0) {
                    [self displayWarningMessage:NSLocalizedString(@"Aún no tienes Beeps. ¡Echa un vistazo a la pestaña de Beeps y apúntate para hacer algo que te interese!", nil)];
                }
                self.myBeepSubscriptions = myBeepSubscriptions;
                [self.tableView reloadData];
            }
        });
    }];
}

#pragma mark - Abstract methods

- (NSUInteger)numberOfSections
{
    return 4;
}

- (NSUInteger)numberOfCellsForSection:(NSUInteger)section
{
    // Return the number of rows in the section.
    NSInteger numberOfRows = 0;

    switch (section) {
        case MJMyBeepsSectionSubscribed:
            numberOfRows = [self.myBeepSubscriptions[@(MJBeepSubscriptionStatusSubscribed)] count];
            break;
        case MJMyBeepsSectionFeedbackSent:
            numberOfRows = [self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackSent)] count];
            break;
        case MJMyBeepsSectionFeedbackDeclined:
            numberOfRows = [self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackDeclined)] count];
            break;
        case MJMyBeepsSectionFeedbackApproved:
            numberOfRows = [self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackApproved)] count];
            break;
    }
    
    return numberOfRows;
}

- (MJBeep *)beepForIndexPath:(NSIndexPath *)indexPath
{
    MJBeepSubscription *subscription = nil;
    
    switch (indexPath.section) {
        case MJMyBeepsSectionSubscribed:
            subscription = self.myBeepSubscriptions[@(MJBeepSubscriptionStatusSubscribed)][indexPath.item];
            break;
        case MJMyBeepsSectionFeedbackSent:
            subscription = self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackSent)][indexPath.item];
            break;
        case MJMyBeepsSectionFeedbackDeclined:
            subscription = self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackDeclined)][indexPath.item];
            break;
        case MJMyBeepsSectionFeedbackApproved:
            subscription = self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackApproved)][indexPath.item];
            break;
    }

    return subscription.beep;
}

- (NSString *)titleForSection:(NSUInteger)section
{
    NSString *title = @"";
    
    switch (section) {
        case MJMyBeepsSectionSubscribed: {
            if ([self.myBeepSubscriptions[@(MJBeepSubscriptionStatusSubscribed)] count] != 0) {
                title = NSLocalizedString(@"Asignados", nil);
            }
        }
            break;
        case MJMyBeepsSectionFeedbackSent: {
            if ([self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackSent)] count] != 0) {
                title = NSLocalizedString(@"En revisión", nil);
            }
        }
            break;
        case MJMyBeepsSectionFeedbackDeclined: {
            if ([self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackDeclined)] count] != 0) {
                title = NSLocalizedString(@"Rechazados", nil);
            }
        }
            break;
        case MJMyBeepsSectionFeedbackApproved: {
            if ([self.myBeepSubscriptions[@(MJBeepSubscriptionStatusFeedbackApproved)] count] != 0) {
                title = NSLocalizedString(@"Completados", nil);
            }
        }
            break;
    }
    
    return title;
};

- (void)reloadDataForLocationChange
{
    [self.tableView reloadData];
};

@end
