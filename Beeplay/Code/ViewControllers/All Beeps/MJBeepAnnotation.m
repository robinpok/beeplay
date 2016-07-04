//
//  MJMapAnnotation.m
//  Beeplay
//
//  Created by Saül Baró on 06/01/2014.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJBeepAnnotation.h"

#import "MJBeep.h"
#import "MJFormatter.h"

@interface MJBeepAnnotation ()

@property (nonatomic) BOOL displayAddress;

@end

@implementation MJBeepAnnotation

- (id)init
{
    return nil;
}

- (instancetype)initWithBeep:(MJBeep *)beep
{
    return [self initWithBeep:beep displayAddress:NO];
}

- (instancetype)initWithBeep:(MJBeep *)beep displayAddress:(BOOL)displayAddress
{
    self = [super init];
    if (self) {
        _beep = beep;
        _displayAddress = displayAddress;
    }
    return self;
}


- (CLLocationCoordinate2D)coordinate
{
    return self.beep.location.coordinate;
}

- (NSString *)title
{
    NSString *title;
    
    if (self.displayAddress) {
        title = self.beep.addressLine1;
    }
    else {
        title = self.beep.title;
    }
    return title;
}

- (NSString *)subtitle
{
    NSString *subtitle;
    
    if (self.displayAddress) {
        subtitle = self.beep.addressLine2;
    }
    else {
        subtitle = [[MJFormatter sharedInstance] formatCurrency:self.beep.price];
    }
    return subtitle;
}

@end
