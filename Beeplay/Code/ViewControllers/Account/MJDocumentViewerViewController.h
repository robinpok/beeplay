//
//  MJDocumentViewerViewController.h
//  Beeplay
//
//  Created by Saül Baró on 10/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, MJDocumentViewerType) {
    MJDocumentViewerTypeTermsOfUse = 0};

@interface MJDocumentViewerViewController : UIViewController

@property (nonatomic) MJDocumentViewerType viewerType;

@end
