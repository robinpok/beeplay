//
//  MJTableSelectorViewController.m
//  Beeplay
//
//  Created by Saül Baró on 10/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;
#import "MJAccountViewController.h"

#import "MJUser.h"

@interface MJTableSelectorViewController : UITableViewController

@property (nonatomic) NSUInteger selectedValue;
@property (strong, nonatomic) NSArray *values;
@property (strong, nonatomic) NSString *unwindSegueIdentifier;
@property (strong, nonatomic) NSMutableArray *selectedInterests;
@property (weak, nonatomic) MJAccountViewController *accountVC;

- (void)didSave;

@end
