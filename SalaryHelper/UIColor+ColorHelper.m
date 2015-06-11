//
//  UIColor+ColorHelper.m
//  SalaryHelper
//
//  Created by Turbo on 5/7/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "UIColor+ColorHelper.h"

@implementation UIColor (ColorHelper)

+ (UIColor *)goldColor
{
    return [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
}

+ (UIColor *)themeBlueColor
{
    return [UIColor colorWithRed:99/255.0 green:172/255.0 blue:233/255.0 alpha:1.0];
}

+ (UIColor *)increaseColor
{
    return [UIColor colorWithRed:102/255.0 green:212/255.0 blue:80/255.0 alpha:1.0];
}

+ (UIColor *)decreaseColor
{
    return [UIColor colorWithRed:255/255.0 green:99/255.0 blue:64/255.0 alpha:1.0];
}

@end
