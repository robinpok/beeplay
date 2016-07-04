//
//  UINavigationBar+BeeplayBar.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 26/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "UIViewController+BeeplayBar.h"

@implementation UIViewController (BeeplayBar)

- (void)addDefaultTitle
{
    UIImage *image = [UIImage imageNamed:@"icon_topbar"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
}

@end
