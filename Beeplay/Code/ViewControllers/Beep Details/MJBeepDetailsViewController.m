//
//  MJBeepDetailsViewController.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJBeepDetailsViewController.h"

#import "MJBeepsViewController.h"

#import "MJBeepMapViewController.h"
#import "MJBeepFeedbackViewController.h"
#import "MJBeepAnnotation.h"

#import "MJController.h"
#import "MJBeep.h"
#import "MJUser.h"
#import "MJBeepSubscription.h"

#import "MJFormatter.h"

#import "UIViewController+AlertMessages.h"
#import "UIViewController+PerformTaskWithProgress.h"
#import "NSError+BeeplayError.h"
#import "UIColor+BeeplayColors.h"

@import MapKit;
@import MessageUI;

@interface MJBeepDetailsViewController () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MKMapViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet MKMapView *addressMapView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIButton *participateButton;

@property (strong, nonatomic) MJBeepSubscription *beepSubscription;

@property (strong, nonatomic) MJBeepAnnotation *beepAnnotation;
@property (strong, nonatomic) MKMapItem *locationItem;

@end

static NSString * const kShowMapSegueIdentifier = @"showMap";
static NSString * const kShowFeedbackSegueIdentifier = @"showFeedbackForm";

@implementation MJBeepDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Atrás", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.participateButton.hidden = YES;
    self.addressMapView.delegate = self;
    
    self.priceView.layer.cornerRadius = 5.0f;
    
    self.participateButton.backgroundColor = [UIColor bp_signUpButtonColor];
    self.participateButton.layer.cornerRadius = 5.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchSubscription)
                                                 name:BeepsViewControllerReloadDataNotification
                                               object:nil];
    [self fetchSubscription];
    [self setupView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupView
{
    if (self.beep) {
        self.title = self.beep.title;
        self.companyNameLabel.text = self.beep.companyName;
        self.priceLabel.text = [[MJFormatter sharedInstance] formatCurrency:self.beep.price];
        self.pointsLabel.text = [[MJFormatter sharedInstance] formatPoints:self.beep.points];

        self.beepAnnotation = [[MJBeepAnnotation alloc] initWithBeep:self.beep
                                                      displayAddress:YES];
        [self.addressMapView showAnnotations:@[self.beepAnnotation] animated:NO];
        [self.addressMapView selectAnnotation:self.beepAnnotation animated:YES];
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.beep.location.coordinate
                                                       addressDictionary:nil];
        self.locationItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [self.locationItem setName:self.beep.companyName];
        
        // FIX: setting the text to nil fixes a problem were it would mark the whole text as a link
        self.descriptionView.text = nil;
        self.descriptionView.text = self.beep.beepDescription;
        
        [self setupParticipateButton];
    }
}

- (void)setupParticipateButton
{
    if (!self.beepSubscription) {
        [self.participateButton setTitle:NSLocalizedString(@"Quiero participar", nil)
                                forState:UIControlStateNormal];
        self.participateButton.hidden = NO;
        self.participateButton.enabled = YES;
    }
    else {
        switch (self.beepSubscription.status) {
            case MJBeepSubscriptionStatusSubscribed:
                [self.participateButton setTitle:NSLocalizedString(@"Enviar información", nil)
                                        forState:UIControlStateNormal];
                self.participateButton.backgroundColor = [UIColor bp_greenButtonColor];
                [self.participateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.participateButton.hidden = NO;
                self.participateButton.enabled = YES;
                break;
            case MJBeepSubscriptionStatusFeedbackSent:
                [self.participateButton setTitle:NSLocalizedString(@"En revisión", nil)
                                        forState:UIControlStateDisabled];
                self.participateButton.backgroundColor = [UIColor bp_logInButtonColor];
                self.participateButton.hidden = NO;
                self.participateButton.enabled = NO;
                break;
            case MJBeepSubscriptionStatusFeedbackApproved:
                [self.participateButton setTitle:NSLocalizedString(@"Información aceptada", nil)
                                        forState:UIControlStateDisabled];
                self.participateButton.backgroundColor = [UIColor bp_logInButtonColor];
                self.participateButton.hidden = NO;
                self.participateButton.enabled = NO;
                break;
            case MJBeepSubscriptionStatusFeedbackDeclined:
                [self.participateButton setTitle:NSLocalizedString(@"Información incorrecta", nil)
                                        forState:UIControlStateDisabled];
                self.participateButton.backgroundColor = [UIColor bp_logInButtonColor];
                self.participateButton.hidden = NO;
                self.participateButton.enabled = NO;
                break;
            case MJBeepSubscriptionStatusTimedOut:
                self.participateButton.hidden = YES;
                break;
        }
    }
}

- (void)fetchSubscription
{
    __block MJBeepSubscription *subscription;
    [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
        subscription = [[MJController sharedInstance] fetchSubsriptionForBeep:self.beep
                                                                        error:error];
    } completionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self displayErrorMessage:[error beeplay_errorDescription]];
            }
            else {
                self.beepSubscription = subscription;
                [self setupView];
            }
        });
    }];
}

#pragma mark - Actions

- (IBAction)participate
{
    if (!self.beepSubscription) {
        __block MJBeepSubscription *subscription;
        [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
            subscription = [[MJController sharedInstance] createSubscriptionForBeep:self.beep
                                                                              error:error];
        } completionHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self displayErrorMessage:[error beeplay_errorDescription]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    self.beepSubscription = subscription;
                    [self setupView];
                    [self alertWithTitle:NSLocalizedString(@"Adelante", nil)
                                 message:NSLocalizedString(@"Envía la información cuando hayas completado el trabajo.", nil)];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:BeepsViewControllerReloadDataNotification
                                                                    object:self];
            });
        }];
    }
    [self setupParticipateButton];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowFeedbackSegueIdentifier]) {
        if ([segue.destinationViewController isMemberOfClass:[MJBeepFeedbackViewController class]]) {
            MJBeepFeedbackViewController *feedbackVC = segue.destinationViewController;
            feedbackVC.beep = self.beep;
            feedbackVC.beepSubscription = self.beepSubscription;
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL should = YES;
    if ([identifier isEqualToString:kShowFeedbackSegueIdentifier]) {
        if (!self.beepSubscription || self.beepSubscription.status != MJBeepSubscriptionStatusSubscribed) {
            should = NO;
        }
    }
    return should;
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    static NSString* BeepIdentifier = @"BeepAnnotationView";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:BeepIdentifier];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:BeepIdentifier];
        pinView.draggable = NO;
        pinView.animatesDrop = NO;
        pinView.enabled = YES;
    }
    else {
        pinView.annotation = annotation;
    }
    
    if ([annotation isEqual:self.beepAnnotation]) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        pinView.canShowCallout = YES;
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isEqual:self.beepAnnotation]) {
        BOOL hasGoogleMaps = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f", 0.0f, 0.0f]]];
        
        UIActionSheet *openInMenu;
        if (hasGoogleMaps) {
            openInMenu = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancelar", nil)
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"Abrir en Mapas", nil), NSLocalizedString(@"Abrir en Google Maps", nil), nil];
        }
        else {
            openInMenu = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancelar", nil)
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"Abrir en Mapas", nil),  nil];
        }
        
        [openInMenu showInView:self.view];
    }
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet
willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //Apple Maps, using the MKMapItem class
        [self.locationItem openInMapsWithLaunchOptions:nil];
    }
    else if (buttonIndex == 1) {
        //Google Maps
        //construct a URL using the comgooglemaps schema
        CLLocationCoordinate2D location = self.locationItem.placemark.coordinate;
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f", self.beep.address, location.latitude, location.longitude];
        NSString *webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:webStringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Mail compose view controller delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES
                                   completion:NULL];
}

@end
