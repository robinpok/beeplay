//
//  MJFormatter.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 26/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJFormatter.h"

@import MapKit;

@interface MJFormatter ()

@property (strong, nonatomic) MKDistanceFormatter *distanceFormatter;
@property (strong, nonatomic) NSNumberFormatter *pointsFormatter;
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

@end

@implementation MJFormatter

+ (MJFormatter *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static MJFormatter *sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[MJFormatter alloc] init];
    });
    return sharedObject;
}

- (MKDistanceFormatter *)distanceFormatter
{
    if (!_distanceFormatter) {
        _distanceFormatter = [[MKDistanceFormatter alloc] init];
        _distanceFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es-es"];
    }
    return _distanceFormatter;
}

- (NSNumberFormatter *)currencyFormatter
{
    if (!_currencyFormatter) {
        _currencyFormatter = [[NSNumberFormatter alloc] init];
        _currencyFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _currencyFormatter.maximumFractionDigits = 2;
        _currencyFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es-es"];
        _currencyFormatter.positiveFormat = @"0.00€";
    }
    return _currencyFormatter;
}

- (NSNumberFormatter *)pointsFormatter
{
    if (!_pointsFormatter) {
        _pointsFormatter = [[NSNumberFormatter alloc] init];
        _pointsFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es-es"];
        _pointsFormatter.positiveFormat = @"# puntos";
    }
    return _pointsFormatter;
}

- (NSString *)formatCurrency:(NSNumber *)currency
{
    return [self.currencyFormatter stringFromNumber:currency];
}

- (NSString *)formatPoints:(NSNumber *)points
{
    return [self.pointsFormatter stringFromNumber:points];
}

- (NSString *)formatDistance:(CLLocationDistance)distance
{
    return [self.distanceFormatter stringFromDistance:distance];
}

@end
