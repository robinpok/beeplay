//
//  MJTutorialViewController.m
//  Beeplay
//
//  Created by Saül Baró on 10/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJTutorialViewController.h"

#import "MJTutorialPageViewController.h"

#import "UIColor+BeeplayColors.h"

@interface MJTutorialViewController () <UIPageViewControllerDataSource,  UIPageViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *pages;
@property (strong, nonatomic) NSArray *pageImages;

@property (nonatomic) NSUInteger currentIndex;

@end

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)

@implementation MJTutorialViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createPages];
    self.dataSource = self;
    [self setViewControllers:@[self.pages[0]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:true
                  completion:nil];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor bp_pageIndicatorColor];
    pageControl.currentPageIndicatorTintColor = [UIColor bp_currentPageIndicatorColor];
}

- (NSArray *)pageImages
{
    if (!_pageImages) {
        if (IS_IPHONE_5) {
            _pageImages = @[@"tutorial1-4inch.png",
                            @"tutorial2-4inch.png",
                            @"tutorial3-4inch.png"];
        }
        else {
            _pageImages = @[@"tutorial1-3inch.png",
                            @"tutorial2-3inch.png",
                            @"tutorial3-3inch.png"];
        }
    }
    return _pageImages;
}

- (void)createPages
{
    self.pages = [[NSMutableArray alloc] init];
    MJTutorialPageViewController *page;
    for (NSString *pageImage in self.pageImages) {
        page = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialPage"];
        page.pageImageName = pageImage;
        [self.pages addObject:page];
        if ([pageImage isEqualToString:[self.pageImages lastObject]]) {
            page.lastPage = YES;
        }
    }
}

#pragma mark - Page view data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    MJTutorialPageViewController *page;
    if ([self.pages firstObject] != viewController) {
        for (NSUInteger i = [self.pages count] - 1; i > 0 ; i--) {
            if (self.pages[i] == viewController) {
                page = self.pages[i - 1];
                self.currentIndex = i - 1;
                break;
            }
        }
    }
    return page;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    MJTutorialPageViewController *page;
    if ([self.pages lastObject] != viewController) {
        for (int i = 0; i < [self.pages count]; i++) {
            if (self.pages[i] == viewController) {
                page = self.pages[i + 1];
                self.currentIndex = i + 1;
                break;
            }
        }
    }
    return page;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.currentIndex;
}


@end
