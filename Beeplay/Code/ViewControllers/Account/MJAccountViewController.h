//
//  MJAccountViewController.h
//  Beeplay
//
//  Created by Saül Baró on 9/27/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, MJAccountViewControllerMode) {
    MJAccountViewControllerModeDefault = 0,
    MJAccountViewControllerModeSignUp
};

@interface MJAccountViewController : UIViewController

@property (nonatomic) MJAccountViewControllerMode mode;

@end
