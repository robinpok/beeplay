//
//  MJBeepMapViewController.m
//  Beeplay
//
//  Created by Saül Baró on 10/14/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJBeepMapViewController.h"

#import "MJBeepAnnotation.h"

@import MapKit;

@interface MJBeepMapViewController () <MKMapViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *openInButton;

@end

@implementation MJBeepMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView showAnnotations:@[self.beepAnnotation] animated:NO];
    [self.mapView selectAnnotation:self.beepAnnotation animated:YES];
}

#pragma mark - Actions

- (IBAction)openIn
{
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
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f", self.locationAddress, location.latitude, location.longitude];
        NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:webStringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
