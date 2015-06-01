//
//  NSDate+DateHelper.m
//  SalaryHelper
//
//  Created by Turbo on 5/6/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "NSDate+DateHelper.h"

@implementation NSDate (DateHelper)

+ (NSDate *)getDateTimeFromStringInUTC:(NSString *)dateString
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:dateString];
    
    return date;
}

+ (NSDate *)getDateFromStringInUTC:(NSString *)dateString
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:dateString];
    
    return date;
}

+ (NSInteger)monthsBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    return [[[NSCalendar currentCalendar] components: NSCalendarUnitMonth
                                            fromDate: date1
                                              toDate: date2
                                             options: 0] month];
}

+ (NSString *)nameForMonth:(NSInteger)month
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(month - 1)];
    
    return monthName;
}

+ (NSString *)getYearFromStringInUTC:(NSString *)dateString
{
    NSDate *date = [self getDateTimeFromStringInUTC:dateString];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setTimeZone:timeZone];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)getMonthFromStringInUTC:(NSString *)dateString
{
    NSDate *date = [self getDateTimeFromStringInUTC:dateString];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    [formatter setTimeZone:timeZone];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)getDayFromStringInUTC:(NSString *)dateString
{
    NSDate *date = [self getDateTimeFromStringInUTC:dateString];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    [formatter setTimeZone:timeZone];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)getCurrentDateTime
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [DateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getCurrentDate
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [DateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getDateStringFromDate:(NSDate *)date
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:date];
}

+ (NSInteger)getNumberOfWeekdayFromStringInUTC:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    dateFormatter.dateFormat=@"e";
    return [[dateFormatter stringFromDate:date] integerValue];
}

+ (NSInteger)getNumberOfDaysInWeek:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange days = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return days.length;
}

+ (NSInteger)getDayFromDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger day = [components day];
    
    return day;
}

+ (NSInteger)getMonthFromDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSInteger month = [components month];
    
    return month;
}

+ (NSInteger)getYearFromDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    
    return year;
}

@end
