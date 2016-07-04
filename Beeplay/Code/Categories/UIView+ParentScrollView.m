//
//  UIView+ParentScrollView.m
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "UIView+ParentScrollView.h"

@implementation UIView (ParentScrollView)

- (UIScrollView *)findParentScrollView
{
    if ([self isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView*)self;
    }

    if (self.superview) {
        return [self.superview findParentScrollView];
    }
    
    return nil;
}

@end
