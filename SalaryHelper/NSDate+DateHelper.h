//
//  NSDate+DateHelper.h
//  SalaryHelper
//
//  Created by Turbo on 5/6/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateHelper)

+ (NSDate *)getDateFromStringInUTC:(NSString *)dateString;

+ (NSInteger)monthsBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;

+ (NSString *)nameForMonth:(NSInteger)month;

+ (NSString *)getYearFromStringInUTC:(NSString *)dateString;

+ (NSString *)getCurrentDateTime;

+ (NSString *)getMonthFromStringInUTC:(NSString *)dateString;

+ (NSString *)getDayFromStringInUTC:(NSString *)dateString;

+ (NSInteger)getNumberOfWeekdayFromStringInUTC:(NSString *)dateString;

+ (NSInteger)getNumberOfDaysInWeek:(NSDate *)date;

+ (NSInteger)getDayFromDate:(NSDate *)date;

+ (NSInteger)getMonthFromDate:(NSDate *)date;

+ (NSInteger)getYearFromDate:(NSDate *)date;

@end
