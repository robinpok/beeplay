//
//  UIImage+Resize.h
//  Beeplay
//
//  Created by Saül Baró on 10/16/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)resizeImageToSize:(CGSize)targetSize;
- (UIImage *)cropImageToSquareSize:(CGSize)targetSize;

@end
