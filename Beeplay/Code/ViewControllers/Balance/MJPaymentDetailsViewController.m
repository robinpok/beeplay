//
//  MJPaymentDetailsViewController.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 27/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJPaymentDetailsViewController.h"

#import "MJTableSelectorViewController.h"
#import "MJController.h"
#import "MJUser.h"
#import "MJBalance.h"
#import "MJSettings.h"

#import "UIViewController+AlertMessages.h"
#import "UIViewController+PerformTaskWithProgress.h"
#import "UIViewController+KeyboardManager.h"
#import "UIView+FirstResponder.h"
#import "NSError+BeeplayError.h"

#import "MJFormatter.h"

@interface MJPaymentDetailsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *paypalMailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *identitiyCardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) NSArray *stateLabels;
@property (nonatomic) NSInteger selectedState;

@property (nonatomic) BOOL previousIsSelector;

@end

static NSString * const kShowStateSelectorSegueIdentifier = @"showStateSelector";
static NSString * const kSelectorUnwindSegueIdentifier = @"setStateSelected";

@implementation MJPaymentDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.saveButton.layer.cornerRadius = 5.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.previousIsSelector) {
        [self setupView];
    }
    else {
        self.previousIsSelector = NO;
    }
}

- (void)setupView
{
    MJUser *currentUser = [[MJController sharedInstance] currentUser];
    
    self.paypalMailAddressField.text = currentUser.paypalEmail;
    self.identitiyCardNumberField.text = currentUser.identityCardNumber;
    self.selectedState = currentUser.state ? [self.stateLabels indexOfObject:currentUser.state] : -1;
    [self setupStateLabel];
}

- (IBAction)saveData
{
    [self resignFirstResponder];
    
    MJUser *user = [[MJController sharedInstance] currentUser];
    user.paypalEmail = self.paypalMailAddressField.text;
    user.identityCardNumber = self.identitiyCardNumberField.text;
    user.state = self.stateField.text;
    
    if (!user.paypalEmail || [user.paypalEmail length] == 0
        || !user.identityCardNumber || [user.identityCardNumber length] == 0
        || !user.state || [user.state length] == 0) {
        [self displayErrorMessage:NSLocalizedString(@"Debes rellenar todos los campos para poder continuar.", nil)];
    }
    else {
        [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
            if (error) {
                *error = [[MJController sharedInstance] updateUser:user];
            }
        } completionHandler:^(NSError *error) {
            if (error) {
                [self displayErrorMessage:[error beeplay_errorDescription]];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupView];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
}

- (void)setupStateLabel
{
    if (self.selectedState >= 0 && self.selectedState < [self.stateLabels count]) {
        self.stateField.text = self.stateLabels[self.selectedState];
    }
}

- (NSArray *)stateLabels
{
    if (!_stateLabels) {
        _stateLabels = @[
                         @"Albacete",
                         @"Alicante/Alacant",
                         @"Almería",
                         @"Araba/Álava",
                         @"Asturias",
                         @"Ávila",
                         @"Badajoz",
                         @"Balears, Illes",
                         @"Barcelona",
                         @"Bizkaia",
                         @"Burgos",
                         @"Cáceres",
                         @"Cádiz",
                         @"Cantabria",
                         @"Castellón/Castelló",
                         @"Ciudad Real",
                         @"Córdoba",
                         @"Coruña, A",
                         @"Cuenca",
                         @"Gipuzkoa",
                         @"Girona",
                         @"Granada",
                         @"Guadalajara",
                         @"Huelva",
                         @"Huesca",
                         @"Jaén",
                         @"León",
                         @"Lleida",
                         @"Lugo",
                         @"Madrid",
                         @"Málaga",
                         @"Murcia",
                         @"Navarra",
                         @"Ourense",
                         @"Palencia",
                         @"Palmas, Las",
                         @"Pontevedra",
                         @"Rioja, La",
                         @"Salamanca",
                         @"Santa Cruz de Tenerife",
                         @"Segovia",
                         @"Sevilla",
                         @"Soria",
                         @"Tarragona",
                         @"Teruel",
                         @"Toledo",
                         @"Valencia/Valéncia",
                         @"Valladolid",
                         @"Zamora",
                         @"Zaragoza",
                         @"Ceuta",
                         @"Melilla",
                         ];
    }
    return _stateLabels;
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.stateField isEqual:textField]) {
        [self showStateSelector];
    }
    return NO;
}

#pragma mark - Navigation

- (void)showStateSelector
{
    [[self.view findFirstResponder] resignFirstResponder];
    [self performSegueWithIdentifier:kShowStateSelectorSegueIdentifier
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowStateSelectorSegueIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[MJTableSelectorViewController class]]) {
            MJTableSelectorViewController *stateSelectorVC = segue.destinationViewController;
            stateSelectorVC.title = NSLocalizedString(@"Provincia", nil);
            stateSelectorVC.values = self.stateLabels;
            stateSelectorVC.selectedValue = self.selectedState;
            stateSelectorVC.unwindSegueIdentifier = kSelectorUnwindSegueIdentifier;
            
            self.previousIsSelector = YES;
        }
    }
}

- (IBAction)stateSelected:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[MJTableSelectorViewController class]]) {
        MJTableSelectorViewController *selectorVC = segue.sourceViewController;
        self.selectedState = selectorVC.selectedValue;
        [self setupStateLabel];
    }
}

@end
