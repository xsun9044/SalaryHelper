//
//  NSDate+DateHelper.h
//  SalaryHelper
//
//  Created by Turbo on 5/6/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateHelper)

/*
 * Translate date string into NSDate
 */
// Datetime from date string
+ (NSDate *)getDateTimeFromStringInUTC:(NSString *)dateString;
// Date from date string
+ (NSDate *)getDateFromStringInUTC:(NSString *)dateString;

/*
 * Date compute
 */
// Month between two dates
+ (NSInteger)monthsBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;
+ (NSInteger)getNumberOfWeekdayFromStringInUTC:(NSString *)dateString;
+ (NSInteger)getNumberOfDaysInWeek:(NSDate *)date;

// Get current date
+ (NSString *)getCurrentDate;
// Get current date time
+ (NSString *)getCurrentDateTime;

+ (NSString *)nameForMonth:(NSInteger)month;

/*
 * Parse the date string
 */
+ (NSString *)getYearFromStringInUTC:(NSString *)dateString;
+ (NSString *)getMonthFromStringInUTC:(NSString *)dateString;
+ (NSString *)getDayFromStringInUTC:(NSString *)dateString;

/*
 * Parse the NSDate
 */
+ (NSInteger)getDayFromDate:(NSDate *)date;
+ (NSInteger)getMonthFromDate:(NSDate *)date;
+ (NSInteger)getYearFromDate:(NSDate *)date;


/*
 * Translate date to date string
 */
+ (NSString *)getDateStringFromDate:(NSDate *)date;
+ (NSString *)getDateStringWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;

@end
