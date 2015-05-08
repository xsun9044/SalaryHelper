//
//  UIImageView+imageViewHelper.m
//  SalaryHelper
//
//  Created by Turbo on 5/7/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "UIImageView+imageViewHelper.h"

@implementation UIImageView (imageViewHelper)

- (void)changeTintColorOfUIImage:(UIImage *)image withColor:(UIColor *)color
{
    self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setTintColor:color];
}

- (void)rotateImage90Degrees
{
    self.transform = CGAffineTransformMakeRotation(M_PI/2);
}

@end
