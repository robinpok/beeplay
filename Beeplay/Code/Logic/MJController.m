//
//  MJController.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJController.h"

#import "MJUser.h"
#import "MJBeep.h"
#import "MJBeepSubscription.h"
#import "MJBalance.h"
#import "MJSettings.h"

#import "MJValidator.h"

@interface MJController ()

@property (strong, nonatomic) NSMutableDictionary *beepSubscriptionsCache;

@property (strong, nonatomic) MJSettings *settings;

@end

static NSString * const kMJControllerErrorDomain = @"MJControllerErrorDomain";

@implementation MJController

+ (MJController *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static MJController* sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[MJController alloc] init];
    });
    return sharedObject;
}

#pragma mark - User management

- (MJUser *)currentUser
{
    return [MJUser currentUser];
}

- (NSError *)createUser:(MJUser *)newUser
{
    NSError *error = nil;
    [newUser signUp:&error];
    NSLog(@"Error %@", [error userInfo]);
    return error;
}

- (NSError *)updateUser:(MJUser *)user
{
    NSError *error = nil;
    [user save:&error];
    NSLog(@"Error %@", [error userInfo]);
    return error;
}

- (NSError *)logInWithUsername:(NSString *)username password:(NSString *)password
{
    NSError *error = nil;
    [MJUser logInWithUsername:username password:password error:&error];
    NSLog(@"Error %@", [error userInfo]);
    return error;
}

- (void)logOutCurrentUser
{
    [MJUser logOut];
}

- (NSError *)passwordResetForEmail:(NSString *)emailAddress
{
    NSError *error = nil;
    if (emailAddress && ![@"" isEqualToString:emailAddress]) {
        if ([[MJValidator sharedInstance] validateEmail:emailAddress]) {
            [MJUser requestPasswordResetForEmail:emailAddress error:&error];
        }
        else {
            error = [NSError errorWithDomain:kMJControllerErrorDomain
                                        code:kPFErrorInvalidEmailAddress
                                    userInfo:nil];
        }
    }
    else {
        error = [NSError errorWithDomain:kMJControllerErrorDomain
                                    code:kPFErrorUserEmailMissing
                                userInfo:nil];
    }
    NSLog(@"Error %@", [error userInfo]);
    return error;
}

#pragma mark - Beep management

- (NSArray *)availableBeeps:(NSError **)error
{
    NSArray *availableBeeps;
    PFQuery *subscriptionsQuery = [MJBeepSubscription query];
    subscriptionsQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    subscriptionsQuery.limit = 1000;
    subscriptionsQuery.maxCacheAge = 60;
    [subscriptionsQuery whereKey:@"user" equalTo:[MJUser currentUser]];
    [subscriptionsQuery whereKey:@"status" equalTo:@(MJBeepSubscriptionStatusFeedbackDeclined)];
    [subscriptionsQuery includeKey:@"beep"];
    NSArray *declinedSubscriptions = [subscriptionsQuery findObjects:error];
    
    NSMutableArray *beepIdsToIgnore = [[NSMutableArray alloc] init];
    for (MJBeepSubscription *subscription in declinedSubscriptions) {
        [beepIdsToIgnore addObject:subscription.beep.objectId];
    }
    
    PFQuery *query = [MJBeep query];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.limit = 1000;
    query.maxCacheAge = 60;
    [query whereKey:@"objectId" notContainedIn:beepIdsToIgnore];
    [query whereKey:@"isFull" equalTo:@NO];
    [query whereKey:@"status" notEqualTo:@(MJBeepStatusCompleted)];
    [query whereKey:@"visibility" equalTo:@(YES)];
    [query orderByDescending:@"price"];
    availableBeeps = [query findObjects:error];

    self.beepSubscriptionsCache = nil;
    return availableBeeps;
}

- (NSMutableDictionary *)beepSubscriptionsCache
{
    if (!_beepSubscriptionsCache) {
        _beepSubscriptionsCache = [[NSMutableDictionary alloc] init];
    }
    return _beepSubscriptionsCache;
}

- (MJBeepSubscription *)createSubscriptionForBeep:(MJBeep *)beep
                                            error:(NSError **)error;
{
    [PFQuery clearAllCachedResults];
    
    MJBeepSubscription *subscription = [MJBeepSubscription object];
    subscription.beep = beep;
    subscription.user = [MJUser currentUser];
    subscription.status = MJBeepSubscriptionStatusSubscribed;
    [subscription save:error];
    
    if (!error) {
        NSString *subscriptionKey = [NSString stringWithFormat:@"%@-%@", beep.objectId, [MJUser currentUser].objectId];
        self.beepSubscriptionsCache[subscriptionKey] = subscription;
    }
    
    return subscription;
}

- (NSError *)updateSubscription:(MJBeepSubscription *)subscription
{
    NSError *error = nil;
    [subscription save:&error];
    NSLog(@"Error %@", [error userInfo]);
    return error;
}

- (MJBeepSubscription *)fetchSubsriptionForBeep:(MJBeep *)beep error:(NSError **)error
{
    MJBeepSubscription *subscription;
    NSString *subscriptionKey = [NSString stringWithFormat:@"%@-%@", beep.objectId, [MJUser currentUser].objectId];
    if (!self.beepSubscriptionsCache[subscriptionKey]) {
        NSArray *subscriptions;
        PFQuery *query = [MJBeepSubscription query];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        query.limit = 1000;
        [query whereKey:@"user" equalTo:[MJUser currentUser]];
        [query whereKey:@"beep" equalTo:beep];
        subscriptions = [query findObjects:error];
        if (subscriptions && [subscriptions count] > 0) {
            self.beepSubscriptionsCache[subscriptionKey] = [subscriptions firstObject];
        }
    }
    subscription = self.beepSubscriptionsCache[subscriptionKey];
    
    return subscription;
}

- (NSDictionary *)mySubscriptionsGroupedByStatus:(NSError **)error
{
    NSArray *mySubscriptions = [self mySubscriptions:error];
    NSMutableDictionary *mySubscriptionsGroupedByStatus = [[NSMutableDictionary alloc] init];
    
    for (MJBeepSubscription *subscription in mySubscriptions) {
        if (subscription.beep) {
            if (subscription.status != MJBeepSubscriptionStatusTimedOut) {
                if (!mySubscriptionsGroupedByStatus[@(subscription.status)]) {
                    mySubscriptionsGroupedByStatus[@(subscription.status)] = [[NSMutableArray alloc] init];
                }
                [mySubscriptionsGroupedByStatus[@(subscription.status)] addObject:subscription];
            }
        }
    }
    
    return [mySubscriptionsGroupedByStatus copy];
}

- (NSArray *)mySubscriptions:(NSError **)error
{
    NSArray *myBeepSubscriptions;
    PFQuery *query = [MJBeepSubscription query];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.limit = 1000;
    [query whereKey:@"user" equalTo:[MJUser currentUser]];
    [query includeKey:@"beep"];
    [query orderByDescending:@"status"];
    myBeepSubscriptions = [query findObjects:error];
    self.beepSubscriptionsCache = nil;
    
    NSString *subscriptionKey;
    NSString *userId = [MJUser currentUser].objectId;
    for (MJBeepSubscription *subscription in myBeepSubscriptions) {
        subscriptionKey = [NSString stringWithFormat:@"%@-%@", subscription.objectId, userId];
        self.beepSubscriptionsCache[subscriptionKey] = subscription;
    }
    
    return myBeepSubscriptions;
}

#pragma mark - Balance management

- (NSError *)refreshBalance
{
    NSError *error = nil;
    [[MJUser currentUser].balance refresh:&error];
    
    if (!error) {
        PFQuery *settingsQuery = [MJSettings query];
        self.settings = (MJSettings *)[settingsQuery getFirstObject:&error];
    }

    NSLog(@"Error %@", [error userInfo]);
    return error;
}

static NSString * const kReclaimEmailFunctionName = @"sendBalanceRequest";

static NSString * const kReclaimEmailFunctionAmountParameter = @"amount";
static NSString * const kReclaimEmailFunctionPaypayEmailParameter = @"paypalEmail";
static NSString * const kReclaimEmailFunctionIdentityCardNumberParameter = @"identitiyCardNumber";
static NSString * const kReclaimEmailFunctionStateParameter = @"state";
static NSString * const kReclaimEmailFunctionUsernameParameter = @"username";
static NSString * const kReclaimEmailFunctionNameParameter = @"name";

- (NSError *)reclaimBalance:(NSString *)amount
{
    NSError *error;
    MJUser *currentUser = self.currentUser;
    NSString *name = [NSString stringWithFormat:@"%@ %@ %@", currentUser.name, currentUser.firstSurname, currentUser.secondSurname];
    [PFCloud callFunction:kReclaimEmailFunctionName
           withParameters: @{
                             kReclaimEmailFunctionAmountParameter : amount,
                             kReclaimEmailFunctionPaypayEmailParameter : currentUser.paypalEmail,
                             kReclaimEmailFunctionIdentityCardNumberParameter : currentUser.identityCardNumber,
                             kReclaimEmailFunctionStateParameter : currentUser.state,
                             kReclaimEmailFunctionUsernameParameter : currentUser.username,
                             kReclaimEmailFunctionNameParameter : name
                             }
                    error:&error];
    return error;
}

#pragma mark - Feedback management

static NSString * const kSendFeedbackFunctionName = @"sendFeedback";

static NSString * const kSendFeedbackFunctionTextParameter = @"text";
static NSString * const kSendFeedbackFunctionImagesParameter = @"images";
static NSString * const kSendFeedbackFunctionBeepTitleParameter = @"beepTitle";
static NSString * const kSendFeedbackFunctionBeeoCompanyNameParameter = @"beepCompanyName";
static NSString * const kSendFeedbackFunctionUsernameParameter = @"username";
static NSString * const kSendFeedbackFunctionNameParameter = @"name";
static NSString * const kSendFeedbackFunctionResponseEmailParameter = @"responseEmail";

static NSString * const kSendFeedbackImageDisctionaryType = @"type";
static NSString * const kSendFeedbackImageDisctionaryName = @"name";
static NSString * const kSendFeedbackImageDisctionaryContent = @"content";

- (NSError *)sendFeedback:(NSString *)text withImages:(NSArray *)images forBeep:(MJBeep *)beep
{
    NSMutableArray *encodedImages = [[NSMutableArray alloc] init];
    for (UIImage *image in images) {
        @autoreleasepool {
            NSData *data = UIImageJPEGRepresentation(image, 0.7);
            NSString *base64EncodedString = [data base64EncodedStringWithOptions:0];
            
            NSUInteger index = [images indexOfObject:image] + 1;
            NSDictionary *imageToSend = @{
                                          kSendFeedbackImageDisctionaryType : @"image/jpeg",
                                          kSendFeedbackImageDisctionaryName : [NSString stringWithFormat:@"Imagen%ld", (long)index],
                                          kSendFeedbackImageDisctionaryContent : base64EncodedString
                                          };
            
            [encodedImages addObject:imageToSend];
        }
    }
    
    NSError *error;
    MJUser *currentUser = self.currentUser;
    NSString *name = [NSString stringWithFormat:@"%@ %@ %@", currentUser.name, currentUser.firstSurname, currentUser.secondSurname];
    
    NSDictionary *parameters = @{
                                 kSendFeedbackFunctionTextParameter : text,
                                 kSendFeedbackFunctionImagesParameter : encodedImages,
                                 kSendFeedbackFunctionBeepTitleParameter : beep.title,
                                 kSendFeedbackFunctionBeeoCompanyNameParameter : beep.companyName,
                                 kSendFeedbackFunctionUsernameParameter : currentUser.username,
                                 kSendFeedbackFunctionNameParameter : name,
                                 kSendFeedbackFunctionResponseEmailParameter : beep.responseEmail
                                 };
    
    [PFCloud callFunction:kSendFeedbackFunctionName
           withParameters:parameters
                    error:&error];

    return error;
}

@end
