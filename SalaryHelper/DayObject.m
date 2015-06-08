//
//  DayObject.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "DayObject.h"

@interface DayObject()

@end

@implementation DayObject

- (DayObject *)initDataWithDay:(NSString *)day InThisMonth:(BOOL)flag

{
    self = [super init];
    
    if (self) {
        _day = day;
        _inThisMonth = flag;
    }
    return self;
}

@end