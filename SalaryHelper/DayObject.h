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

@property (nonatomic) BOOL inThisMonth;
@property (nonatomic) BOOL isToday;

- (DayObject *)initDataWithDay:(NSString *)day InThisMonth:(BOOL)flag;

@end
