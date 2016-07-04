//
//  MJSplashViewController.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 26/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJSplashViewController.h"

#import "MJAccountViewController.h"

#import "UIColor+BeeplayColors.h"

@interface MJSplashViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation MJSplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.signUpButton.backgroundColor = [UIColor bp_signUpButtonColor];
    self.signUpButton.layer.cornerRadius = 5.0f;
    
    self.logInButton.backgroundColor = [UIColor bp_logInButtonColor];
    self.logInButton.layer.cornerRadius = 5.0f;
    self.logInButton.layer.borderWidth = 1.0f;
    self.logInButton.layer.borderColor = [[UIColor bp_logInBorderButtonColor] CGColor];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = segue.destinationViewController;
        if ([navController.topViewController respondsToSelector:@selector(setMode:)]) {
            ((MJAccountViewController *)navController.topViewController).mode = MJAccountViewControllerModeSignUp;
        }
    }
}

@end
