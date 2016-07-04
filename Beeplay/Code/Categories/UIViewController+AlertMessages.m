//
//  UIViewController+AlertMessages.m
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "UIViewController+AlertMessages.h"

#import <objc/runtime.h>

#import <SVProgressHUD/SVProgressHUD.h>

@implementation UIViewController (AlertMessages)

- (void)displayErrorMessage:(NSString *)errorMessage
{
    [self alertWithTitle:NSLocalizedString(@"Error", nil)
                 message:errorMessage];
}

-(void)displayWarningMessage:(NSString *)warningMessage
{
    [self alertWithTitle:NSLocalizedString(@"Atención", nil)
                 message:warningMessage];
}

- (void)displaySuccessMessage:(NSString *)successMessage
{
    [self alertWithTitle:NSLocalizedString(@"!Hecho!", nil)
                 message:successMessage];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    [self displayAlertWithTitle:title
                        message:message
                       delegate:nil
                        buttons:@[NSLocalizedString(@"OK", nil)]];
}

- (void)displayConfirmationMessage:(NSString *)confirmationMessage
                          delegate:(id<UIAlertViewDelegate>)delegate;
{
    [self displayAlertWithTitle:NSLocalizedString(@"Atención", nil)
                        message:confirmationMessage
                       delegate:delegate
                        buttons:@[NSLocalizedString(@"No", nil),
                                  NSLocalizedString(@"Sí", nil)]];
}

- (void)displaySuccessStatus:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
}

- (void)displayLoginSuccesForUser:(NSString *)userName
{
    [self displaySuccessStatus:[NSString stringWithFormat:NSLocalizedString(@"Bienvenido a Beeplay, %@!", @"Welcome to Beeplay, {User First Name}"), userName]];
}

- (void)displayAlertWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<UIAlertViewDelegate>)delegate
                      buttons:(NSArray *)buttons
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    for (NSString *buttonTitle in buttons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayAlertView:alert];
    });
}


static char PendingAlertKey;

- (void)displayPendingAlerts
{
    UIAlertView *pendingAlert = objc_getAssociatedObject(self, &PendingAlertKey);
    if (pendingAlert) {
        [pendingAlert show];
        objc_setAssociatedObject(self, &PendingAlertKey, nil, OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)displayAlertView:(UIAlertView *)alert
{
    // show the alert view if this view controller is currently visible
    if (self.isViewLoaded && self.view.window) {
        [alert show];
    }
    else {
        objc_setAssociatedObject(self, &PendingAlertKey, alert, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
