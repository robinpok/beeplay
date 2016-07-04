//
//  MJMapAnnotation.h
//  Beeplay
//
//  Created by Saül Baró on 06/01/2014.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@class MJBeep;

@interface MJBeepAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic, readonly) MJBeep *beep;

// Designared initializer
- (instancetype)initWithBeep:(MJBeep *)beep displayAddress:(BOOL)displayAddress;
- (instancetype)initWithBeep:(MJBeep *)beep;

@end
