//
//  UIView+ViewHelper.m
//  SalaryHelper
//
//  Created by Turbo on 5/14/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "UIView+ViewHelper.h"

@implementation UIView (ViewHelper)

- (void)showAlertBorderWithCornerRadius:(CGFloat)radius
{
    self.layer.borderColor=[[UIColor redColor]CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)hideAlertBorder
{
    self.layer.borderColor=[[UIColor clearColor]CGColor];
    self.layer.borderWidth = 0;
}

@end
