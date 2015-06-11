//
//  DayView.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "DayView.h"
#import "UIColor+ColorHelper.h"

@interface DayView()

@property (nonatomic, strong) UILabel *day;
@property (nonatomic, strong) UILabel *incomeAmount;
@property (nonatomic, strong) UILabel *outlayAmount;

@property (nonatomic, strong) UIView *incomeView;
@property (nonatomic, strong) UIView *outlayView;
@property (nonatomic, strong) UIView *overlay;

@end


@implementation DayView

- (DayView *)initDayViewWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.borderWidth = 0.25f;
        self.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0] CGColor];
        
        self.day = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 36, 23)];
        [self.day setTextAlignment:NSTextAlignmentCenter];
        [self.day setFont:[UIFont fontWithName:@"HelveticaNeue" size: 13.0f]];
        self.day.text = @"1";
        [self addSubview:self.day];
        
        self.incomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 23-4, frame.size.width, (frame.size.height-23+4)/2)];
        [self.incomeView setBackgroundColor:[UIColor increaseColor]];
        self.incomeAmount = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, frame.size.width-16, self.incomeView.frame.size.height)];
        self.incomeAmount.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 11.0f];
        self.incomeAmount.textColor = [UIColor whiteColor];
        self.incomeAmount.text = @"+ $1,500";
        [self.incomeAmount setTextAlignment:NSTextAlignmentRight];
        [self.incomeView addSubview:self.incomeAmount];
        [self addSubview:self.incomeView];
        
        self.outlayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.incomeView.frame.origin.y + self.incomeView.frame.size.height, frame.size.width, (frame.size.height-23+4)/2)];
        [self.outlayView setBackgroundColor:[UIColor decreaseColor]];
        self.outlayAmount = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, frame.size.width-16, self.outlayView.frame.size.height)];
        self.outlayAmount.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 11.0f];
        self.outlayAmount.textColor = [UIColor whiteColor];
        self.outlayAmount.text = @"- $1,500";
        [self.outlayAmount setTextAlignment:NSTextAlignmentRight];
        [self.outlayView addSubview:self.outlayAmount];
        [self addSubview:self.outlayView];
        
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.overlay setBackgroundColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.8]];
        [self addSubview:self.overlay];
    }
    return self;
}

- (void)setDayText:(NSString *)day hideCover:(BOOL)willHide isToday:(BOOL)isToday willShowIncomeBar:(BOOL)willShowIncomeBar willShowOutlayBar:(BOOL)willShowOutlayBar
{
    self.day.text = day;
    self.overlay.hidden = willHide;
    self.incomeView.hidden = !willHide || !willShowIncomeBar;
    self.outlayView.hidden = !willHide || !willShowOutlayBar;
    if (isToday) {
        self.day.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] CGColor];
        self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    }
}

- (void)setWeekendDayTitle
{
    [self.day setTextColor:[UIColor redColor]];
}

- (BOOL)isInThisMonth
{
    return self.overlay.hidden;
}

@end