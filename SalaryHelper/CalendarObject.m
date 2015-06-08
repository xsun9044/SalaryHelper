//
//  CalendarObject.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "CalendarObject.h"
#import "NSDate+DateHelper.h"
#import "SystemHelper.h"
#import "DayObject.h"

@interface CalendarObject()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic) NSInteger startWeekDayOfMonth;

@end

@implementation CalendarObject

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
        [_dateFormatter setTimeZone:timeZone];
    }
    
    return _dateFormatter;
}

- (CalendarObject *)initDataWithCurrentMonthIndexRow:(NSInteger)row

{
    self = [super init];
    
    if (self) {
        _currentMonthIndex = row;
        _month = row%12 + 1;
        _monthName = [NSDate nameForMonth:row%12 + 1];
        _year = [[NSDate getYearFromStringInUTC:startDate] integerValue] + row / 12;
        
        NSDate *date = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",[[NSDate getYearFromStringInUTC:startDate] integerValue] + row / 12,row%12 + 1,1]];
        _daysOfLastMonth = [NSDate getNumberOfDaysInWeek:date];
        
        NSInteger nextMonth = row%12 + 2;
        if (nextMonth > 12) {
            nextMonth = 1;
        } else if (nextMonth < 2) {
            nextMonth = 1;
        }
        
        if (nextMonth == 1) {
            date = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",[[NSDate getYearFromStringInUTC:startDate] integerValue] + row / 12 + 1,(long)nextMonth,1]];
        } else {
            date = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",[[NSDate getYearFromStringInUTC:startDate] integerValue] + row / 12,(long)nextMonth,1]];
        }
        _daysOfCurrentMonth = [NSDate getNumberOfDaysInWeek:date];
        
        _startWeekDayOfMonth = [NSDate getNumberOfWeekdayFromStringInUTC:[NSString stringWithFormat:@"%ld-%@-%d",[[NSDate getYearFromStringInUTC:startDate] integerValue] + row / 12,[NSDate nameForMonth:row%12 + 1],1]];
        
        _daysArray = [[NSMutableArray alloc] init];
        
        [self createDaysInMonth];
    }
    return self;
}

- (void)createDaysInMonth
{
    for (int i=0; i<self.startWeekDayOfMonth-1; i++) { // days of last month
        DayObject *day = [[DayObject alloc] initDataWithDay:[NSString stringWithFormat:@"%ld", self.daysOfLastMonth - (self.startWeekDayOfMonth - 2 - i)] InThisMonth:NO];
        [self.daysArray addObject:day];
    }
    for (int i=0; i<self.daysOfCurrentMonth; i++) { // days in month
        DayObject *day = [[DayObject alloc] initDataWithDay:[NSString stringWithFormat:@"%ld", i + 1] InThisMonth:YES];
        [self.daysArray addObject:day];
    }
    
    self.daysArray.count % 7
}

@end