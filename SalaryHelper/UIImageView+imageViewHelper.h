//
//  UIImageView+imageViewHelper.h
//  SalaryHelper
//
//  Created by Turbo on 5/7/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (imageViewHelper)

- (void)changeTintColorOfUIImage:(UIImage *)image withColor:(UIColor *)color;

- (void)rotateImage90Degrees;

- (void)rotateImage180Degrees;

@end
