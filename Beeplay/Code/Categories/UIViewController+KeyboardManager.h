//
//  UIViewController+KeyboardManager.h
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;

@interface UIViewController (KeyboardManager)

- (IBAction)nextTextField:(UITextField *)sender;
- (IBAction)dismissKeyboard;

- (void)keyboardShowOrHideNotification:(NSNotification *)notification;

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden
            withNotificationInfo:(NSDictionary *)notificationInfo;

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden
           withAnimationDuration:(NSTimeInterval)animationDuration
                           curve:(UIViewAnimationCurve)curve
                  keyboardHeight:(CGFloat)keyboardHeight;

@end
