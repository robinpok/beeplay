//
//  MJBeepCell.h
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;

@interface MJBeepCell : UITableViewCell

extern CGFloat const kMJBeepCellHeight;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@end
