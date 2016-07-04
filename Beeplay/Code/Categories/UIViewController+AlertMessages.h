//
//  UIViewController+AlertMessages.h
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;

@interface UIViewController (AlertMessages)

- (void)alertWithTitle:(NSString *)title message:(NSString *)message;

- (void)displayErrorMessage:(NSString *)errorMessage;
- (void)displayWarningMessage:(NSString *)warningMessage;
- (void)displaySuccessMessage:(NSString *)successMessage;

- (void)displayConfirmationMessage:(NSString *)confirmationMessage
                          delegate:(id<UIAlertViewDelegate>)delegate;

- (void)displaySuccessStatus:(NSString *)message;

- (void)displayPendingAlerts;

// Login messages
- (void)displayLoginSuccesForUser:(NSString *)userName;

@end
