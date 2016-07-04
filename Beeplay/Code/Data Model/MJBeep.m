//
//  MJBeep.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 26/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJBeep.h"

#import <Parse/PFObject+Subclass.h>

@interface MJBeep () {
    CLLocation *_location;
}

@end

@implementation MJBeep

#pragma mark - Properties

@dynamic companyName;
@dynamic title;
@dynamic price;
@dynamic points;

@dynamic address;
@dynamic addressLine1;
@dynamic addressLine2;

@dynamic latitude;
@dynamic longitude;

@dynamic beepDescription;
@dynamic responseEmail;
@dynamic status;

@dynamic geolocationRequired;
@dynamic photoRequired;
@dynamic cameraRollAllowed;
@dynamic visibility;

#pragma mark - Super class method overriding

+ (instancetype)object
{
    MJBeep *beep = (MJBeep *)[super object];
    
    beep.companyName = @"";
    beep.title = @"";
    beep.price = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    beep.points = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    beep.address = @"";
    beep.addressLine1 = @"";
    beep.addressLine2 = @"";
    beep.latitude = 0.0;
    beep.longitude = 0.0;
    beep.beepDescription = @"";
    beep.responseEmail = @"";
    beep.status = MJBeepStatusNoUsers;
    beep.geolocationRequired = NO;
    beep.photoRequired = NO;
    beep.cameraRollAllowed = NO;
    beep.visibility = NO;

    return beep;
}

/*! The name of the class as seen in the REST API. */
+ (NSString *)parseClassName
{
    return @"Beep";
}

#pragma mark - Location

- (CLLocation *)location
{
    if (!_location) {
        _location = [[CLLocation alloc] initWithLatitude:self.latitude
                                               longitude:self.longitude];
    }
    return _location;
}

@end
