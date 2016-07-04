//
//  MJFormatter.h
//  Beeplay
//
//  Created by Saül Baró Ruiz on 26/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface MJFormatter : NSObject

- (NSString *)formatCurrency:(NSNumber *)currency;
- (NSString *)formatPoints:(NSNumber *)points;
- (NSString *)formatDistance:(CLLocationDistance)distance;

+ (MJFormatter *)sharedInstance;

@end
