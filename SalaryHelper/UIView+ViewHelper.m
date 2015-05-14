//
//  UIView+ViewHelper.m
//  SalaryHelper
//
//  Created by Turbo on 5/14/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "UIView+ViewHelper.h"
@interface UIView ()

@property (nonatomic, strong) UIColor *restoreColor;

@end

@implementation UIView (ViewHelper)

- (void)showAlertBorder
{
    self.restoreColor = [UIColor colorWithCGColor:self.layer.borderColor];
    self.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)hideAlertBorder
{
    self.layer.borderColor = [self.restoreColor CGColor];
}

@end
