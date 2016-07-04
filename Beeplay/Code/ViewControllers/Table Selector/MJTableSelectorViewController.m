//
//  MJTableSelectorViewController.m
//  Beeplay
//
//  Created by Saül Baró on 10/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJTableSelectorViewController.h"

@interface MJTableSelectorViewController () 
{
    BOOL isInterestVC;
    NSMutableArray *tempSelectedInterests;
}
@end

@implementation MJTableSelectorViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setSelectedValue:(NSUInteger)selectedValue
{
    self.tableView.allowsMultipleSelection = NO;
    isInterestVC = NO;
    
    if (_selectedValue != selectedValue) {
        _selectedValue = selectedValue;
        [self.tableView reloadData];
    }
}

- (void)setSelectedInterests:(NSMutableArray *)selectedInterests
{
    _selectedInterests = selectedInterests;
    tempSelectedInterests = [NSMutableArray arrayWithArray:_selectedInterests];
    self.tableView.allowsMultipleSelection = YES;
    isInterestVC = YES;

    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                           forIndexPath:indexPath];

    cell.textLabel.text = self.values[indexPath.item];
    if (isInterestVC) {
        cell.accessoryType = [self.selectedInterests[indexPath.row] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else
        cell.accessoryType = self.selectedValue == indexPath.item ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isInterestVC) {
        [self onRowClicked:tableView indexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        self.selectedValue = indexPath.item;
        [tableView reloadData];
        [self performSegueWithIdentifier:self.unwindSegueIdentifier
                                  sender:self];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isInterestVC) {
        [self onRowClicked:tableView indexPath:indexPath];
    }
}

-(void)onRowClicked:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    tempSelectedInterests[indexPath.row] = [NSNumber numberWithBool:![tempSelectedInterests[indexPath.row] boolValue]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([tempSelectedInterests[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)didSave
{
    /*
    for (int i = 0; i < self.selectedInterests.count; i++) {
        self.selectedInterests[i] = [NSNumber numberWithBool:NO];
    }
    
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    for (int i = 0; i < selectedIndexPaths.count; i++) {
        self.selectedInterests[[selectedIndexPaths[i] row]] = [NSNumber numberWithBool:YES];
    }
     */
    self.selectedInterests = tempSelectedInterests;
    
    [self performSegueWithIdentifier:self.unwindSegueIdentifier
                              sender:self];
}

@end