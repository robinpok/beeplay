//
//  UIViewController+PerformTaskWithProgress.h
//  Beeplay
//
//  Created by Saül Baró on 10/1/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;

@interface UIViewController (PerformTaskWithProgress)

- (void)performTaskWithProgress:(void (^)(NSError **error))task
              completionHandler:(void (^)(NSError *error))completionHandler;

- (void)performTask:(void (^)(NSError **error))task
       withProgress:(BOOL)showProgress
  completionHandler:(void (^)(NSError *error))completionHandler;

@end
