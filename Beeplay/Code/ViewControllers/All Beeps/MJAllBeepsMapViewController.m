//
//  MJAllBeepsMapViewController.m
//  Beeplay
//
//  Created by Saül Baró on 06/01/2014.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJAllBeepsMapViewController.h"

#import "MJController.h"
#import "MJBeep.h"
#import "MJBeepDetailsViewController.h"

#import "MJBeepsViewController.h"

#import "MJBeepAnnotation.h"

#import "UIViewController+PerformTaskWithProgress.h"
#import "UIViewController+AlertMessages.h"
#import "NSError+BeeplayError.h"

@import MapKit;

@interface MJAllBeepsMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSArray *mapAnnotations;

@end

static NSString * const kShowBeepDetailsSegueIdentifier = @"showBeepDetails";

@implementation MJAllBeepsMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:BeepsViewControllerReloadDataNotification
                                               object:nil];
    [self setupMapView];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.tabBar.translucent = NO;
        self.tabBarController.tabBar.translucent = YES;
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self displayPendingAlerts];
}

- (void)setupMapView
{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)reloadData
{
    [self fetchBeeps:nil];
}

#pragma mark - Actions

- (IBAction)reloadBeeps:(id)sender
{
    [self reloadData];
}

#pragma mark - Fetch beeps

- (void)fetchBeeps:(UIRefreshControl *)control
{
    __block NSArray *availableBeeps;
    [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
        availableBeeps = [[MJController sharedInstance] availableBeeps:error];
        
    } completionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self displayErrorMessage:[error beeplay_errorDescription]];
            }
            else {
                if ([availableBeeps count] == 0) {
                    [self displayWarningMessage:NSLocalizedString(@"Todos los Beeps ya están asignados, vuelve a pasarte por aquí más tarde.", nil)];
                }
                [self updateMapWithBeeps:availableBeeps];
            }
        });
    }];
}

#pragma mark - Helpers

- (void)updateMapWithBeeps:(NSArray *)beeps
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (MJBeep *beep in beeps) {
        [annotations addObject:[[MJBeepAnnotation alloc] initWithBeep:beep]];
    }
    [self.mapView removeAnnotations:self.mapAnnotations];
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [annotations addObject:self.mapView.userLocation];
    }
    self.mapAnnotations = annotations;
    [self.mapView showAnnotations:self.mapAnnotations animated:YES];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    double inset = -zoomRect.size.width * 0.1;
    [self.mapView setVisibleMapRect:MKMapRectInset(zoomRect, inset, inset) animated:YES];
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = nil;
    if ([annotation isKindOfClass:[MJBeepAnnotation class]]) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                              reuseIdentifier:@"beepPin"];
        pin.pinColor = MKPinAnnotationColorRed;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.rightCalloutAccessoryView = rightButton;
    }

    return pin;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[MJBeepAnnotation class]]) {
        [self performSegueWithIdentifier:kShowBeepDetailsSegueIdentifier
                                  sender:view.annotation];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowBeepDetailsSegueIdentifier]
        && [sender isKindOfClass:[MJBeepAnnotation class]]) {
        MJBeepAnnotation *annotation = (MJBeepAnnotation *)sender;
        MJBeep *beep = annotation.beep;
        if ([segue.destinationViewController respondsToSelector:@selector(setBeep:)]) {
            [segue.destinationViewController performSelector:@selector(setBeep:)
                                                  withObject:beep];
        }
    }
}

@end
