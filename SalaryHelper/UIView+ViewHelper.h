//
//  UIView+ViewHelper.h
//  SalaryHelper
//
//  Created by Turbo on 5/14/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewHelper)

- (void)showAlertBorderWithCornerRadius:(CGFloat)radius;

- (void)hideAlertBorder;

- (void)makeBorderWithCorner:(CGFloat)radius andWidth:(CGFloat)width andColor:(UIColor*)color;

- (void)makeRoundedCornerWithoutBorder:(CGFloat)radius;

@end
