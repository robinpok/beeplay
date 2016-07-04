//
//  MJDatePickerViewController.h
//  Beeplay
//
//  Created by ProDev on 2/22/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJDatePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (strong, nonatomic) NSDate* date;

- (void) didSave;
@end
