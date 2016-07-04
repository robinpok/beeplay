//
//  UIViewController+KeyboardManager.m
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "UIViewController+KeyboardManager.h"

#import "UIView+FirstResponder.h"
#import "UIView+ParentScrollView.h"

@implementation UIViewController (KeyboardManager)

#pragma mark - Actions

/*! This method makes first responder the UITextView with a tag value 
 * equal to the current text field tag plus one.
 * \param sender The current text field
 */
- (IBAction)nextTextField:(UITextField *)sender
{
    NSUInteger nextElementTag = sender.tag + 1;
    UIView *nextElement = [self.view viewWithTag:nextElementTag];
    if ([nextElement isKindOfClass:[UITextField class]  ]) {
        [nextElement becomeFirstResponder];
    }
}

- (IBAction)dismissKeyboard
{
    [[self.view findFirstResponder] resignFirstResponder];
}

#pragma mark - React to the appearance or dismissal of the keyboard

- (void)keyboardShowOrHideNotification:(NSNotification *)notification
{
    [self keyboardWillBecomeHidden:[notification.name isEqualToString:UIKeyboardWillHideNotification]
              withNotificationInfo:[notification userInfo]];
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withNotificationInfo:(NSDictionary *)notificationInfo
{
    UIViewAnimationCurve animationCurve;
    [[notificationInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    CGRect keyboardFrameAtEndOfAnimation;
    [[notificationInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameAtEndOfAnimation];
    
    CGFloat keyboardHeight = keyboardFrameAtEndOfAnimation.size.height;
    NSTimeInterval animationDuration = [[notificationInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self keyboardWillBecomeHidden:keyboardHidden
             withAnimationDuration:animationDuration
                             curve:animationCurve
                    keyboardHeight:keyboardHeight];
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden
           withAnimationDuration:(NSTimeInterval)animationDuration
                           curve:(UIViewAnimationCurve)curve
                  keyboardHeight:(CGFloat)keyboardHeight
{
    UIEdgeInsets insets;
    UIView *firstReponder;
    UIScrollView *parentScrollView;
    
    firstReponder = [self.view findFirstResponder];
    parentScrollView = [firstReponder findParentScrollView];
    
    if (parentScrollView) {
        insets = parentScrollView.contentInset;
        
        CGFloat tabBarHeight = [self.bottomLayoutGuide length];
        
        insets.bottom = keyboardHidden ? tabBarHeight : keyboardHeight;
        
        [UIView animateWithDuration:0.3 animations:^{
            parentScrollView.contentInset = insets;
            parentScrollView.scrollIndicatorInsets = insets;
        } completion:^(BOOL finished) {
            if (!keyboardHidden) {
                CGRect fieldRect = [firstReponder.superview convertRect:firstReponder.frame
                                                                 toView:parentScrollView];
                fieldRect = CGRectInset(fieldRect, 0, -25.0f);
                [parentScrollView scrollRectToVisible:fieldRect
                                             animated:YES];
            }
        }];
    }
}

@end
