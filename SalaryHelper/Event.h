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
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString* amount;

- (Event *)initEventWithDetail:(NSInteger)rowID
                         Title:(NSString *)title
                     andAmount:(NSString *)amount
                   andStarDate:(NSString *)startDate;

@end
