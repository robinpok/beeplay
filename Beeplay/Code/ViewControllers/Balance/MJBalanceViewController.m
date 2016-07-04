//
//  MJBalanceViewController.m
//  Beeplay
//
//  Created by Saül Baró on 9/27/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJBalanceViewController.h"

#import "MJTableSelectorViewController.h"
#import "MJController.h"
#import "MJUser.h"
#import "MJBalance.h"
#import "MJSettings.h"

#import "UIViewController+AlertMessages.h"
#import "UIViewController+PerformTaskWithProgress.h"
#import "NSError+BeeplayError.h"

#import "UIColor+BeeplayColors.h"

#import "MJFormatter.h"

@interface MJBalanceViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *accumulatedMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *accumulatedPointsLabel;

@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (weak, nonatomic) IBOutlet UIView *progressBarContainer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UIButton *reclaimButton;
@property (weak, nonatomic) IBOutlet UIButton *paymentDataButton;

@property (strong, nonatomic) NSArray *stateLabels;
@property (nonatomic) NSInteger selectedState;

@property (nonatomic) BOOL previousIsSelector;

@end

static NSString * const kBalanceMinimumAmount = @"50";

static NSString * const kShowPaymentDetailsSegueIdentifier = @"showPaymentDetails";
static NSString * const kSelectorUnwindSegueIdentifier = @"setPaymentDetails";

@implementation MJBalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.previousIsSelector = NO;

    self.reclaimButton.backgroundColor = [UIColor bp_orangeButtonDisabledColor];
    self.reclaimButton.layer.cornerRadius = 5.0f;
    [self.reclaimButton setTitleColor:[UIColor bp_buttonDisabledTextColor]
                             forState:UIControlStateDisabled];
    [self.reclaimButton setTitleShadowColor:[UIColor bp_buttonDisabledTextColor]
                             forState:UIControlStateDisabled];
    
    self.paymentDataButton.backgroundColor = [UIColor bp_signUpButtonColor];
    self.paymentDataButton.layer.cornerRadius = 5.0f;
    
    [self.progressBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progressBar(width)]"
                                                                             options:0
                                                                             metrics:@{@"width" : @(14)}
                                                                               views:@{@"progressBar": self.progressBar}]];
    
    self.progressBarContainer.layer.cornerRadius = 2.0f;
    self.progressBarContainer.layer.masksToBounds = YES;
    self.progressBarContainer.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.previousIsSelector) {
        [self refreshBalance];
    }
    else {
        self.previousIsSelector = NO;
    }
}

- (void)refreshBalance
{
    [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
        [[MJController sharedInstance] refreshBalance];
    }
                completionHandler:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            [self displayErrorMessage:[error beeplay_errorDescription]];
                        }
                        [self setupView];
                    });
                }];
}

- (void)setupView
{
    MJUser *currentUser = [[MJController sharedInstance] currentUser];
    MJBalance *balance = currentUser.balance;
    self.balanceLabel.text = [[MJFormatter sharedInstance] formatCurrency:balance.accountBalance];
    
    self.accumulatedMoneyLabel.text = [[MJFormatter sharedInstance] formatCurrency:balance.accumulatedMoneyBalance];
    self.accumulatedPointsLabel.text = [[MJFormatter sharedInstance] formatPoints:balance.pointsBalance];
    
    MJSettings *settings = [[MJController sharedInstance] settings];
    NSString *instructionsLabelText;
    if ([balance.accumulatedPointsBalance compare:settings.minimumPointsBalanceToReclaim] == NSOrderedAscending) {
        instructionsLabelText = [NSString stringWithFormat:@"Podrás solicitar el pago a tu cuenta de PayPal cuando tengas más de %@", [[MJFormatter sharedInstance] formatPoints:settings.minimumPointsBalanceToReclaim]];
    }
    else {
        instructionsLabelText = [NSString stringWithFormat:@"Podrás solicitar el pago a tu cuenta de PayPal cuando hayas acumulado un mínimo de %@", [[MJFormatter sharedInstance] formatCurrency:settings.minimumMoneyBalanceToReclaim]];
    }
    self.progressBar.progress = [balance.accountBalance doubleValue]/[settings.minimumMoneyBalanceToReclaim doubleValue];
    self.progressBar.progressTintColor = [UIColor bp_blueButtonColor];
    self.instructionsLabel.text = instructionsLabelText;
    
    if ([balance.accountBalance compare:settings.minimumMoneyBalanceToReclaim] == NSOrderedAscending
        || [balance.accumulatedPointsBalance compare:settings.minimumPointsBalanceToReclaim] == NSOrderedAscending) {
        self.reclaimButton.enabled = NO;
        self.reclaimButton.backgroundColor = [UIColor bp_orangeButtonDisabledColor];
    }
    else {
        self.reclaimButton.enabled = YES;
        self.reclaimButton.backgroundColor = [UIColor bp_signUpButtonColor];
    }
}

- (IBAction)reclaim
{
    if (self.reclaimButton.enabled) {
        MJUser *user = [[MJController sharedInstance] currentUser];
        
        if (!user.paypalEmail || [user.paypalEmail length] == 0
            || !user.identityCardNumber || [user.identityCardNumber length] == 0
            || !user.state || [user.state length] == 0) {
            [self displayErrorMessage:NSLocalizedString(@"Debes introducir los datos de pago para poder continuar.", nil)];
        }
        else {
            user.balance.accountBalance = [NSDecimalNumber decimalNumberWithString:@"0.0"];
            
            [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
                if (error) {
                    *error = [[MJController sharedInstance] updateUser:user];
                    if (!*error) {
                        NSString *amount = [self.balanceLabel.text substringToIndex:[self.balanceLabel.text length] - 1];
                        *error = [[MJController sharedInstance] reclaimBalance:amount];
                    }
                }
            } completionHandler:^(NSError *error) {
                if (error) {
                    [self displayErrorMessage:[error beeplay_errorDescription]];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertWithTitle:NSLocalizedString(@"Solicitud enviada", nil)
                                     message:NSLocalizedString(@"Beeplay revisará tu solicitud y en breve recibirás el saldo en tu cuenta de PayPal.", nil)];
                        [self setupView];
                    });
                }
            }];
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowPaymentDetailsSegueIdentifier]) {
        self.previousIsSelector = YES;
    }
}

@end
