//
//  UIView+FindAndResignFirstResponder.h
//  Beeplay
//
//  Created by Saül Baró on 9/27/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;

@interface UIView (FirstResponder)

/**
 Get the current first responder without using a private API
 http://stackoverflow.com/questions/1823317/get-the-current-first-responder-without-using-a-private-api
 */
- (UIView *)findFirstResponder;

@end
