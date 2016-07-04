//
//  MJAppDelegate.m
//  Beeplay
//
//  Created by Saül Baró Ruiz on 25/09/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJAppDelegate.h"

#import "MJUser.h"
#import "MJBeep.h"
#import "MJBeepSubscription.h"
#import "MJBalance.h"
#import "MJSettings.h"

#import "UIColor+BeeplayColors.h"

#import <Parse/Parse.h>

@implementation MJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor bp_tintColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor bp_navigationBarColor]];
    [[UITextField appearance] setBackgroundColor:[UIColor bp_textFieldBackgroundColor]];
    [[UITabBar appearance] setTintColor:[UIColor bp_tintColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor bp_navigationBarColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [UIColor bp_tintColor],
       }];
    
    
    // Registering MJUser as a PFUser subclass
    [MJUser registerSubclass];
    
    // Registering MJBeep as the class to represent Beeps
    [MJBeep registerSubclass];
    
    // Resgistering MJBeepSubscription to represent BeepSubscriptions
    [MJBeepSubscription registerSubclass];

    // Resgistering MJBalance to represent Balance
    [MJBalance registerSubclass];
    
    // Resgistering MJSettings to represent Settings
    [MJSettings registerSubclass];
    
    // Setting the identifiers to use with parse
    
#if defined (CONFIGURATION_DEBUG)
    // Debug
    [Parse setApplicationId:@"8CjiZVMZVIkGYKKQOSUi0lhLdYp0hJC6YBQLxL69"
                  clientKey:@"CwatLpxs9UvxpkqAla8HNonn7XLhyUr2h5NtoCoI"];
    [[UIApplication sharedApplication] performSelector:@selector(setApplicationBadgeString:)
                                            withObject:@"ˠ"];
#elif defined (CONFIGURATION_DEVELOPMENT)
    // Development
    [Parse setApplicationId:@"8CjiZVMZVIkGYKKQOSUi0lhLdYp0hJC6YBQLxL69"
                  clientKey:@"CwatLpxs9UvxpkqAla8HNonn7XLhyUr2h5NtoCoI"];
    [[UIApplication sharedApplication] performSelector:@selector(setApplicationBadgeString:)
                                            withObject:@"α"];
#elif defined (CONFIGURATION_TEST)
    // Test
    [Parse setApplicationId:@"6usE5O1ka3XKvNsQdWGqCDcRShg8xqp3qP4RhMmZ"
                  clientKey:@"aldbrfctMPuRD4WOYRdEsqkZXEyLpQT8rnWOU2pC"];
    /*
    [[UIApplication sharedApplication] performSelector:@selector(setApplicationBadgeString:)
                                            withObject:@"β"];*/
#elif defined (CONFIGURATION_RELEASE)
    // Prod
    [Parse setApplicationId:@"uqP6NkjgqzJfmQb4TqqLdpXpauO5TO5PUXii0ydg"
                  clientKey:@"l52hq4bz7tvF1tAVBzMLt0t5XTgn0BcKlnNATksU"];
#endif
    
    // This is used to track statistics around application opens
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Push Notification
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    if ([MJUser currentUser]) {
        UITabBarController *mainVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        self.window.rootViewController = mainVC;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
//    currentInstallation.channels = @[ @"global" ];
    currentInstallation[@"user"] = [PFUser currentUser];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
