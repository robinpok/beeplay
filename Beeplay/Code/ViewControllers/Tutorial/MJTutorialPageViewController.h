//
//  MJTutorialPageViewController.h
//  Beeplay
//
//  Created by Saül Baró on 10/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJTutorialPageViewController : UIViewController

@property (strong, nonatomic) NSString *pageImageName;
@property (nonatomic, getter = isLastPage) BOOL lastPage;

@end
