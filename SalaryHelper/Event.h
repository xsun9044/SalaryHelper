//
//  Event.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//
#import "ReturnData.h"

@interface Event : ReturnData

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *eventStartDate;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *repeat;
@property (nonatomic, strong) NSString *type;

- (Event *)initEventWithDetail:(NSInteger)rowID
                         Title:(NSString *)title
                     andAmount:(NSString *)amount
                   andStarDate:(NSString *)eventStartDate
                     andRepeat:(NSString *)repeat
                       andType:(NSString *)type;

@end
