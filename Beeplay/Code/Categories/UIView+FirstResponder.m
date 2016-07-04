//
//  UIView+FindAndResignFirstResponder.m
//  Beeplay
//
//  Created by Saül Baró on 9/27/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

@end
