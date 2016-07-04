//
//  MJImageCell.h
//  Beeplay
//
//  Created by Saül Baró on 10/16/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
