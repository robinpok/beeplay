//
//  MJUser.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 26/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJUser.h"
#import "MJBalance.h"

@interface MJUser ()

@end

@implementation MJUser

#pragma mark - Properties

@dynamic name;
@dynamic surname;
@dynamic firstSurname;
@dynamic secondSurname;
@dynamic gender;
@dynamic birthday;
@dynamic postalCode;
@dynamic educationalAttainment;
@dynamic occupation;
@dynamic interests;

@dynamic balance;
@dynamic paypalEmail;
@dynamic identityCardNumber;
@dynamic state;

#pragma mark - Super class method overriding

+ (MJUser *)user
{
    MJUser *user = [[self class] object];
    return user;
}

+ (instancetype)object
{
    MJUser *user = (MJUser *)[super object];
    
    user.name = @"";
    user.surname = @"";
    user.firstSurname = @"";
    user.secondSurname = @"";
    user.gender = MJUserGenderMale;
    user.birthday = [NSDate date];
    user.postalCode = @"";
    user.educationalAttainment = MJUserEducationalAttainmentNoValue;
    user.occupation = 0;
    user.interests = [NSMutableArray array];
    
    user.balance = [MJBalance object];
    
    user.paypalEmail = @"";
    user.identityCardNumber = @"";
    user.state = @"";
    
    return user;
}

@end
