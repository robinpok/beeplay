//
//  MJUser.h
//  Beeplay
//
//  Created by Saül Baró Ruiz on 26/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import Foundation;

#import <Parse/PFUser.h>

@class MJBalance;

typedef NS_ENUM(NSUInteger, MJUserGender) {
    MJUserGenderMale = 0,
    MJUserGenderFemale
};

typedef NS_ENUM(NSUInteger, MJUserEducationalAttainment) {
    MJUserEducationalAttainmentNone = 0,
    MJUserEducationalAttainmentBasicStudies,
    MJUserEducationalAttainmentHighSchool,
    MJUserEducationalAttainmentVocationalTraining,
    MJUserEducationalAttainmentUniversityStudies,
    MJUserEducationalAttainmentMastersDegree,
    MJUserEducationalAttainmentNoValue = 99
};

@interface MJUser : PFUser

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *surname;
@property (strong, nonatomic) NSString *firstSurname, *secondSurname;
@property (nonatomic) MJUserGender gender;
@property (nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSString *postalCode;
@property (nonatomic) MJUserEducationalAttainment educationalAttainment;
@property (nonatomic) NSUInteger occupation;
@property (strong, nonatomic) NSMutableArray *interests;

@property (strong, nonatomic) MJBalance *balance;

@property (strong, nonatomic) NSString *paypalEmail;
@property (strong, nonatomic) NSString *identityCardNumber;
@property (strong, nonatomic) NSString *state;

@end
