//
//  UIViewController+PerformTaskWithProgress.m
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;

#import <SVProgressHUD/SVProgressHUD.h>

@implementation UIViewController (PerformTaskWithProgress)

- (void)performTaskWithProgress:(void (^)(NSError **error))task
              completionHandler:(void (^)(NSError *error))completionHandler
{
    [self performTask:task
         withProgress:YES
    completionHandler:completionHandler];
}

- (void)performTask:(void (^)(NSError **error))task
       withProgress:(BOOL)showProgress
  completionHandler:(void (^)(NSError *error))completionHandler
{
    if (showProgress) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    __block NSError *error;
    dispatch_queue_t taskQ = dispatch_queue_create("cat.mobilejazz.TaskQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(taskQ, ^{
        task(&error);
    });
    if (showProgress) {
        dispatch_async(taskQ, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
    }
    dispatch_async(taskQ, ^{
        completionHandler(error);
    });
}

@end
