//
//  MJAccountViewController.m
//  Beeplay
//
//  Created by Saül Baró on 9/27/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJAccountViewController.h"
#import "MJDatePickerViewController.h"
#import "MJUser.h"
#import "MJController.h"
#import "MJDocumentViewerViewController.h"
#import "MJTableSelectorViewController.h"

#import "NSError+BeeplayError.h"
#import "UIViewController+PerformTaskWithProgress.h"
#import "UIViewController+AlertMessages.h"

#import "UIColor+BeeplayColors.h"
#import "UIViewController+BeeplayBar.h"
#import "UIView+FirstResponder.h"

#import <Parse/Parse.h>

@interface MJAccountViewController () <UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *surnameField;
@property (weak, nonatomic) IBOutlet UITextField *secondSurnameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelector;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeField;
@property (weak, nonatomic) IBOutlet UITextField *educationalAttainmentField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;
@property (weak, nonatomic) IBOutlet UITextField *occupationField;
@property (weak, nonatomic) IBOutlet UITextField *interestsField;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *termsOfUseLabel;
@property (weak, nonatomic) IBOutlet UIButton *termsOfUseButton;

@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSArray *occupationLabels;
@property (strong, nonatomic) NSArray *interestLabels;

@property (strong, nonatomic) NSArray *educationalAttainmentLabels;
@property (nonatomic) MJUserEducationalAttainment selectedEducationalAttainment;

@property (nonatomic) NSUInteger selectedOccupation;
@property (strong, nonatomic) NSMutableArray *selectedInterests;

@property (nonatomic) BOOL previousIsSelector;

@end

static NSString * const kShowEducationalAttainmentSegueIdentifier = @"showEducationalAttainment";
static NSString * const kShowTermsOfUseAndPrivacyPolicySegueIdentifier = @"showTermsOfUseAndPrivacyPolicy";
static NSString * const kShowBirthdayPickerSegueIdentifier =
    @"showBirthday";
static NSString * const kShowOccupationSegueIdentifier =
    @"showOccupation";
static NSString * const kShowInterestsSegueIdentifier =
    @"showInterests";


static NSString * const kLogOutSegueIdentifier = @"logOut";
static NSString * const kSignedUpSegueIdentifier = @"signedUp";
static NSString * const kSelectorSetEducationalSegueIdentifier = @"setEducationalAttainment";
static NSString * const kSelectorSetOccupationSegueIdentifier = @"setOccupation";
static NSString * const kSelectorSetInterestsSegueIdentifier = @"setInterests";

@implementation MJAccountViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Atrás", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    self.saveButton.backgroundColor = [UIColor bp_signUpButtonColor];
    self.saveButton.layer.cornerRadius = 5.0f;

    self.logOutButton.backgroundColor = [UIColor bp_logInButtonColor];
    self.logOutButton.layer.cornerRadius = 5.0f;
    self.logOutButton.layer.borderWidth = 1.0f;
    self.logOutButton.layer.borderColor = [[UIColor bp_logInBorderButtonColor] CGColor];
    
    NSMutableAttributedString *termsButtonString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Condiciones de Uso y Política de privacidad", nil)];
    
    [termsButtonString addAttribute:NSUnderlineStyleAttributeName
                                         value:@(NSUnderlineStyleSingle)
                                         range:NSMakeRange(0, [termsButtonString length])];
    
    [termsButtonString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor bp_navigationBarColor]
                                         range:NSMakeRange(0, [termsButtonString length])];
    
    [self.termsOfUseButton setAttributedTitle:termsButtonString
                                           forState:UIControlStateNormal];
    
    self.selectedEducationalAttainment = MJUserEducationalAttainmentNoValue;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.interestsField.rightView = paddingView;
    self.interestsField.rightViewMode = UITextFieldViewModeAlways;
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
    if (currentUser) {
        self.emailField.text = currentUser.email;
        self.passwordField.text = currentUser.password;
        self.nameField.text = currentUser.name;
        
        if (!currentUser.firstSurname || !currentUser.secondSurname || [currentUser.firstSurname isEqualToString:@""] || [currentUser.secondSurname isEqualToString:@""]) {
            if (![currentUser.surname isEqualToString:@""]) {
                NSArray *array = [currentUser.surname componentsSeparatedByString:@" "];
                currentUser.firstSurname = array[0];
                if (array.count > 1) {
                    currentUser.secondSurname = array[1];
                }
            }
        }
        self.surnameField.text = currentUser.firstSurname;
        self.secondSurnameField.text = currentUser.secondSurname;
        self.genderSelector.selectedSegmentIndex = currentUser.gender;
        self.birthday = currentUser.birthday;
        self.birthdayField.text = [self stringFromDate:self.birthday];
        self.selectedOccupation = currentUser.occupation;
        self.occupationField.text = self.occupationLabels[self.selectedOccupation];
        self.selectedInterests = currentUser.interests;
        self.interestsField.text = [self implode:self.selectedInterests];
        self.postalCodeField.text = currentUser.postalCode;
        self.selectedEducationalAttainment = currentUser.educationalAttainment;
        
        [self setupEducationalAttainmentLabel];
    }
    
    if (self.mode == MJAccountViewControllerModeDefault) {
        [self.saveButton setTitle:NSLocalizedString(@"Guardar", nil)
                         forState:UIControlStateNormal];
        
        self.navigationItem.leftBarButtonItem = nil;
        self.title = NSLocalizedString(@"Mi perfil", nil);
        self.termsOfUseButton.hidden = YES;
        self.termsOfUseLabel.hidden = YES;
    } else if (self.mode == MJAccountViewControllerModeSignUp) {
        [self addDefaultTitle];

        [self.saveButton setTitle:NSLocalizedString(@"Registrarme", nil)
                         forState:UIControlStateNormal];
        
        self.logOutButton.hidden = YES;
        
        self.cancelButton.title = NSLocalizedString(@"Cancelar", nil);
        self.selectedOccupation = 99;
    }
    if (!self.selectedInterests) {
        self.selectedInterests = [NSMutableArray array];
        for (int i = 0; i < [self interestLabels].count; i++) {
            [self.selectedInterests addObject:[NSNumber numberWithBool:NO]];
        }
    }
}

- (void)setupEducationalAttainmentLabel
{
    self.educationalAttainmentField.text = self.educationalAttainmentLabels[self.selectedEducationalAttainment];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMode:(MJAccountViewControllerMode)mode
{
    _mode = mode;
    [self setupView];
}

- (NSArray *)educationalAttainmentLabels
{
    if (!_educationalAttainmentLabels) {
        _educationalAttainmentLabels = @[
                                         NSLocalizedString(@"Sin estudios", nil),
                                         NSLocalizedString(@"Estudios básicos", nil),
                                         NSLocalizedString(@"Bachillerato", nil),
                                         NSLocalizedString(@"Formación profesional", nil),
                                         NSLocalizedString(@"Estudios universitarios", nil),
                                         NSLocalizedString(@"Est. universitarios superiores", nil)
                                         ];
    }
    return _educationalAttainmentLabels;
}

- (NSArray *)occupationLabels
{
    if (!_occupationLabels) {
        _occupationLabels = @[
                             NSLocalizedString(@"Admin. Pública", nil),
                             NSLocalizedString(@"Actividades primarias", nil),
                             NSLocalizedString(@"Arquitectura y construcción", nil),
                             NSLocalizedString(@"Arte", nil),
                             NSLocalizedString(@"Banca", nil),
                             NSLocalizedString(@"Comercio", nil),
                             NSLocalizedString(@"Comunicación", nil),
                             NSLocalizedString(@"Deporte", nil),
                             NSLocalizedString(@"Derecho", nil),
                             NSLocalizedString(@"Educación", nil),
                             NSLocalizedString(@"Gran Consumo", nil),
                             NSLocalizedString(@"Hostelería y turismo", nil),
                             NSLocalizedString(@"Inmobiliaria", nil),
                             NSLocalizedString(@"Internet y tecnologías", nil),
                             NSLocalizedString(@"Salud", nil),
                             NSLocalizedString(@"Transporte", nil),
                             NSLocalizedString(@"Otro", nil)
                             ];

    }
    
    return _occupationLabels;
}

- (NSArray *)interestLabels
{
    if (!_interestLabels)
    {
        _interestLabels = @[
          NSLocalizedString(@"Animales", nil),
          NSLocalizedString(@"Arte", nil),
          NSLocalizedString(@"Cine", nil),
          NSLocalizedString(@"Deporte", nil),
          NSLocalizedString(@"Fiesta", nil),
          NSLocalizedString(@"Gastronomía", nil),
          NSLocalizedString(@"Literatura", nil),
          NSLocalizedString(@"Moda", nil),
          NSLocalizedString(@"Música", nil),
          NSLocalizedString(@"Política", nil),
          NSLocalizedString(@"Salud", nil),
          NSLocalizedString(@"Tecnología", nil),
          NSLocalizedString(@"Viajes", nil),
          NSLocalizedString(@"Otro", nil)
          ];
    }
    
    return _interestLabels;
}
#pragma mark - Actions

- (IBAction)saveUserData
{
//    [[self.view findFirstResponder] resignFirstResponder];
    
    MJUser *user = nil;
    if (self.mode == MJAccountViewControllerModeDefault) {
        user = [MJUser currentUser];
    }
    else if (self.mode == MJAccountViewControllerModeSignUp) {
        user = [MJUser object];
    }
    
    user.username = self.emailField.text;
    user.email = self.emailField.text;
    user.password = self.passwordField.text;
    user.name = self.nameField.text;
    user.firstSurname = self.surnameField.text;
    user.secondSurname = self.secondSurnameField.text;
    user.surname = [NSString stringWithFormat:@"%@ %@", user.firstSurname, user.secondSurname];
    user.gender = self.genderSelector.selectedSegmentIndex;
    user.birthday = self.birthday;
    user.occupation = self.selectedOccupation;
    user.interests = self.selectedInterests;
    user.postalCode = self.postalCodeField.text;
    user.educationalAttainment = self.selectedEducationalAttainment;

    
    if (!user.username || [user.username length] == 0
        || !user.email || [user.email length] == 0
        || ((!user.password || [user.password length] == 0) && self.mode == MJAccountViewControllerModeSignUp)
        || !user.name || [user.name length] == 0
        || !user.firstSurname || [user.firstSurname length] == 0
        || !user.secondSurname || [user.secondSurname length] == 0
        || !user.birthday
        || user.occupation == 99
        || [self.interestsField.text isEqualToString:@""]
        || !user.postalCode || [user.postalCode length] == 0
        || user.educationalAttainment == MJUserEducationalAttainmentNoValue) {
        [self displayErrorMessage:NSLocalizedString(@"Debes rellenar todos los campos para poder continuar.", nil)];
    }
    else {
        [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
            if (error) {
                if (self.mode == MJAccountViewControllerModeDefault) {
                    *error = [[MJController sharedInstance] updateUser:user];
                }
                else if (self.mode == MJAccountViewControllerModeSignUp) {
                    *error = [[MJController sharedInstance] createUser:user];
                }
            }
        } completionHandler:^(NSError *error) {
            if (error) {
                [self displayErrorMessage:[error beeplay_errorDescription]];
            }
            else {
                if (self.mode == MJAccountViewControllerModeDefault) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self displaySuccessStatus:NSLocalizedString(@"Datos actualizados correctamente", nil)];
                    });
                }
                else if (self.mode == MJAccountViewControllerModeSignUp) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self displayLoginSuccesForUser:user.name];
                        [self performSegueWithIdentifier:kSignedUpSegueIdentifier sender:self];
                    });
                }
            }
        }];
    }
}

- (IBAction)logOut
{
    if (self.mode == MJAccountViewControllerModeDefault) {
        [self displayConfirmationMessage:[NSString stringWithFormat:NSLocalizedString(@"Se va a cerrar la sesión del usuario %@ ¿Estás seguro?", nil),
                                          [MJUser currentUser].username]
                                delegate:self];
    }
    else if (self.mode == MJAccountViewControllerModeSignUp){
        [self dismissViewControllerAnimated:YES
                                 completion:NULL];
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
            [[MJController sharedInstance] logOutCurrentUser];
        } completionHandler:^(NSError *error) {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:kLogOutSegueIdentifier sender:self];
            });
        }];
    }
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
    if ([self.educationalAttainmentField isEqual:textField]) {
        [[self.view findFirstResponder] resignFirstResponder];
        [self showEducationalAttainment];
    }
    else if ([textField isEqual:self.birthdayField]){
        [[self.view findFirstResponder] resignFirstResponder];
        [self resignFirstResponder];
        [self performSegueWithIdentifier:kShowBirthdayPickerSegueIdentifier
                                  sender:self];
    }
    else if ([textField isEqual:self.occupationField]){
        [[self.view findFirstResponder] resignFirstResponder];
        [self resignFirstResponder];
        [self performSegueWithIdentifier:kShowOccupationSegueIdentifier
                                  sender:self];
    }
    else if ([textField isEqual:self.interestsField]){
        [[self.view findFirstResponder] resignFirstResponder];
        [self resignFirstResponder];
        [self performSegueWithIdentifier:kShowInterestsSegueIdentifier
                                  sender:self];
    }
    return NO;
}

#pragma mark - Navigation

- (void)showEducationalAttainment
{
    [self resignFirstResponder];
    [self performSegueWithIdentifier:kShowEducationalAttainmentSegueIdentifier
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowEducationalAttainmentSegueIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[MJTableSelectorViewController class]]) {
            MJTableSelectorViewController *educationalSelectiorVC = segue.destinationViewController;
            educationalSelectiorVC.title = @"Nivel de estudios";
            educationalSelectiorVC.values = self.educationalAttainmentLabels;
            educationalSelectiorVC.selectedValue = self.selectedEducationalAttainment;
            educationalSelectiorVC.unwindSegueIdentifier = kSelectorSetEducationalSegueIdentifier;
            
            self.previousIsSelector = YES;
        }
    }
    else if ([segue.identifier isEqualToString:kShowBirthdayPickerSegueIdentifier])
    {
        MJDatePickerViewController *birthdayPickerVC = segue.destinationViewController;
        birthdayPickerVC.title = @"Cumpleaños";
        birthdayPickerVC.date = self.birthday;
        
        self.previousIsSelector = YES;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:birthdayPickerVC action:@selector(didSave)];
        birthdayPickerVC.navigationItem.rightBarButtonItem = doneButton;
    }
    else if ([segue.identifier isEqualToString:kShowOccupationSegueIdentifier]) {
        MJTableSelectorViewController *occupationSelectiorVC = segue.destinationViewController;
        occupationSelectiorVC.title = @"Ocupación";
        occupationSelectiorVC.values = self.occupationLabels;
        occupationSelectiorVC.selectedValue = self.selectedOccupation;
        occupationSelectiorVC.unwindSegueIdentifier = kSelectorSetOccupationSegueIdentifier;
        
        self.previousIsSelector = YES;

    }
    else if  ([segue.identifier isEqualToString:kShowInterestsSegueIdentifier]) {
        MJTableSelectorViewController *interestsSelectiorVC = segue.destinationViewController;
        interestsSelectiorVC.title = @"Intereses";
        interestsSelectiorVC.values = self.interestLabels;
        interestsSelectiorVC.selectedInterests = self.selectedInterests;
        interestsSelectiorVC.unwindSegueIdentifier = kSelectorSetInterestsSegueIdentifier;
        
        self.previousIsSelector = YES;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:interestsSelectiorVC action:@selector(didSave)];
        interestsSelectiorVC.navigationItem.rightBarButtonItem = doneButton;

    }
    else if ([segue.identifier isEqualToString:kShowTermsOfUseAndPrivacyPolicySegueIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[MJDocumentViewerViewController class]]) {
            MJDocumentViewerViewController *documentVC = segue.destinationViewController;
            documentVC.viewerType = MJDocumentViewerTypeTermsOfUse;
            
            self.previousIsSelector = YES;
        }
    }
}

- (IBAction)educationalAttainmentSelected:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[MJTableSelectorViewController class]]) {
        MJTableSelectorViewController *educationalVC = segue.sourceViewController;
        self.selectedEducationalAttainment = educationalVC.selectedValue;
        [self setupEducationalAttainmentLabel];
    }
}

- (IBAction)occupationSelected:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[MJTableSelectorViewController class]]) {
        MJTableSelectorViewController *occupationVC = segue.sourceViewController;
        self.selectedOccupation = occupationVC.selectedValue;
        self.occupationField.text = self.occupationLabels[self.selectedOccupation];
    }
}

- (IBAction)interestsSelected:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[MJTableSelectorViewController class]]) {
        MJTableSelectorViewController *interestsVC = segue.sourceViewController;
  
        self.selectedInterests = interestsVC.selectedInterests;
        self.interestsField.text = [self implode:self.selectedInterests];
    }

}

- (IBAction)birthdaySelected:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[MJDatePickerViewController class]]) {
        MJDatePickerViewController *birthdayPickVC = segue.sourceViewController;
        
        self.birthday = birthdayPickVC.date;
        self.birthdayField.text = [self stringFromDate:self.birthday];
    }

}

- (NSString *)implode:(NSArray*)array
{
    NSString *str = @"";
    for (int i = 0; i < array.count; i++) {
        BOOL b = [array[i] boolValue];
        if (b) {
            str = [NSString stringWithFormat:@"%@, %@", str, self.interestLabels[i]];
        }
    }
    
    if (![str isEqualToString:@""]) {
        str = [str substringFromIndex:2];
    }
        
    return str;
}

- (NSString *)stringFromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    return [formatter stringFromDate:date];
}
@end
