//
//  DayObject.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DayObject : NSObject

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *fullDate;

@property (nonatomic) BOOL inThisMonth;
@property (nonatomic) BOOL isToday;

@property (nonatomic) NSArray *events;

- (DayObject *)initDataWithDay:(NSString *)day InThisMonth:(BOOL)flag;
- (DayObject *)initDataWithDay:(NSString *)day InThisMonth:(BOOL)flag andFullDate:(NSString *)dateString;

- (void)getEventForDay;

@end
