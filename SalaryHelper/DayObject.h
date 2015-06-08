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

- (CalendarObject *)initDataWithCurrentMonthIndexRow:(NSInteger)row;

@end
