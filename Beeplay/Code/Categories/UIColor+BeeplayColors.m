//
//  UIColor+BeeplayColors.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "UIColor+BeeplayColors.h"

@implementation UIColor (BeeplayColors)

+ (instancetype)bp_tintColor
{
    return [UIColor whiteColor];
}

+ (instancetype)bp_navigationBarColor
{
    return [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0];
}

+ (instancetype)bp_textFieldBackgroundColor
{
    return [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
}

+ (instancetype)bp_signUpButtonColor
{
    return [UIColor colorWithRed:255.0/255.0 green:175.0/255.0 blue:52.0/255.0 alpha:1.0];
}

+ (instancetype)bp_logInButtonColor
{
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (instancetype)bp_logInBorderButtonColor
{
    return [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
}

+ (instancetype)bp_pageIndicatorColor
{
    return [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:.5f];
}

+ (instancetype)bp_currentPageIndicatorColor
{
    return [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:1.f];
}

+ (instancetype)bp_greenButtonColor
{
    return [UIColor colorWithRed:94.f/255.f green:174.f/255.f blue:59.f/255.f alpha:1.f];
}

+ (instancetype)bp_blueButtonColor
{
    return [UIColor colorWithRed:80.f/255.f green:161.f/255.f blue:207.f/255.f alpha:1.f];
}

+ (instancetype)bp_orangeButtonDisabledColor
{
    return [UIColor colorWithRed:254.f/255.f green:239.f/255.f blue:207.f/255.f alpha:1.f];
}

+ (instancetype)bp_buttonDisabledTextColor
{
    return [UIColor whiteColor];
}

@end
