//
//  CalendarObject.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CalendarObject : NSObject

@property (nonatomic, strong) NSString *monthName;

@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger daysOfLastMonth;
@property (nonatomic) NSInteger daysOfCurrentMonth;
@property (nonatomic) NSInteger currentMonthIndex;
@property (nonatomic) NSInteger month;

@property (nonatomic, strong) NSMutableArray *daysArray;

@property (nonatomic, strong) CalendarObject *priorMonth;
@property (nonatomic, strong) CalendarObject *nextMonth;

@property (nonatomic) BOOL hasToday;
@property (nonatomic) NSInteger todayDay;
@property (nonatomic) NSInteger todayWeekDay;


- (CalendarObject *)initThereMonthsWithCurrentMonthIndexRow:(NSInteger)row;
- (CalendarObject *)initDataWithCurrentMonthIndexRow:(NSInteger)row;
- (CalendarObject *)initDataWhenMoveRight:(CalendarObject *)obj and:(CalendarObject *)leftObj;
- (CalendarObject *)initDataWhenMoveLeft:(CalendarObject *)obj and:(CalendarObject *)rightObj;

@end
