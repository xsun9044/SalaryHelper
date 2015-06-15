//
//  DayView.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DayView : UIView

- (void)setWeekendDayTitle;
- (void)setDayText:(NSString *)day hideCover:(BOOL)willHide isToday:(BOOL)isToday willShowIncomeBar:(BOOL)willShowIncomeBar willShowOutlayBar:(BOOL)willShowOutlayBar;

- (DayView *)initDayViewWithFrame:(CGRect)frame;

- (BOOL)isInThisMonth;

- (void)setIncomeTitle:(NSString *)title;

@end
