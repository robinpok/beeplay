//
//  MJDatePickerViewController.m
//  Beeplay
//
//  Created by ProDev on 2/22/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJDatePickerViewController.h"
#import "UIViewController+AlertMessages.h"

@interface MJDatePickerViewController ()

@end

@implementation MJDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.date) {
        self.birthdayPicker.date = self.date;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) didSave
{
    self.date = self.birthdayPicker.date;
    NSInteger curYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger birthYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self.date];
    
    if (curYear - birthYear < 18) {
        [self alertWithTitle:@"¡Oh no!" message:@"Debes ser mayor de edad para utilizar Beeplay."];
        return;
    }
    [self performSegueWithIdentifier:@"setDate" sender:self];
}

@end
