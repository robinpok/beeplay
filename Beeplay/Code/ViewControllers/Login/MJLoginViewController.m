//
//  MJLoginViewController.m
//  Beeplay
//
//  Created by Saül Baró on 9/30/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJLoginViewController.h"
#import "MJAccountViewController.h"

#import "MJController.h"
#import "MJUser.h"
#import "NSError+BeeplayError.h"

#import "UIViewController+BeeplayBar.h"
#import "UIColor+BeeplayColors.h"

#import "UIViewController+AlertMessages.h"
#import "UIViewController+PerformTaskWithProgress.h"
#import "UIViewController+KeyboardManager.h"
#import "UIView+FirstResponder.h"
#import "MJValidator.h"
#import <Parse/Parse.h>

@interface MJLoginViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *passwordRecoveryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logInButton;

@end

static NSString * const kLogInSegueIdentifier = @"logIn";

@implementation MJLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDefaultTitle];
    
    NSMutableAttributedString *passwordRecoveryButtonString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Recuperar contraseña", nil)];
    
    [passwordRecoveryButtonString addAttribute:NSUnderlineStyleAttributeName
                                         value:@(NSUnderlineStyleSingle)
                                         range:NSMakeRange(0, [passwordRecoveryButtonString length])];
    
    [passwordRecoveryButtonString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor bp_navigationBarColor]
                                         range:NSMakeRange(0, [passwordRecoveryButtonString length])];
    
    [self.passwordRecoveryButton setAttributedTitle:passwordRecoveryButtonString
                                           forState:UIControlStateNormal];
}

#pragma mark - UI Actions

- (IBAction)logIn
{
    [self dismissKeyboard];
    [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
        if (error) {
            *error = [[MJController sharedInstance] logInWithUsername:self.emailField.text
                                                             password:self.passwordField.text];
        }
    } completionHandler:^(NSError *error) {
        if (error) {
            [self displayErrorMessage:[error beeplay_errorDescription]];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                //    currentInstallation.channels = @[ @"global" ];
                currentInstallation[@"user"] = [PFUser currentUser];
                [currentInstallation saveInBackground];
                
                [self performSegueWithIdentifier:kLogInSegueIdentifier sender:self];
            });
        }
    }];
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)requestPasswordReset
{
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Recuperar contraseña", nil)
                                                         message:NSLocalizedString(@"Por favor, introduce tu dirección de e-mail.", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancelar", nil)
                                               otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    resetAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    // Set the keyboard type for the single text input to email
    [resetAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
    [resetAlert show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Password reset
    if (buttonIndex == 1) {
        NSString *emailAddress = [alertView textFieldAtIndex:0].text;
        [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
            if (error) {
                *error = [[MJController sharedInstance] passwordResetForEmail:emailAddress];
            }
        } completionHandler:^(NSError *error) {
            if (error) {
                [self displayErrorMessage:[error beeplay_errorDescription]];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displaySuccessMessage:NSLocalizedString(@"Se han mandado las instrucciones para recuperar la contraseña.", nil)];
                });
            }
        }];
    }
}

@end
