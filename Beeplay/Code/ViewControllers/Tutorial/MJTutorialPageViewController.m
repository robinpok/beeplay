//
//  MJTutorialPageViewController.m
//  Beeplay
//
//  Created by Saül Baró on 10/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJTutorialPageViewController.h"

@interface MJTutorialPageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *pageImage;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation MJTutorialPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageImage.image = [UIImage imageNamed:self.pageImageName];
    if (self.lastPage) {
        self.startButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.startButton.layer.borderWidth = 1.0f;
        self.startButton.layer.cornerRadius = 5.0f;
        self.startButton.hidden = NO;
    }
    else {
        self.startButton.hidden = YES;
    }
    
    NSString *buttonConstraint;
    if (IS_IPHONE_5) {
        buttonConstraint = @"V:[startButton]-140-|";
    }
    else {
        buttonConstraint = @"V:[startButton]-100-|";
    }
    
    [self.startButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *viewsDictionary = @{ @"startButton" : self.startButton };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:buttonConstraint
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
}

@end
