//
//  Event.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "Event.h"

@implementation Event

/*
 * Event Object
 * All the events retrieved from database
 */
- (Event *)initEventWithDetail:(NSInteger)rowID
                         Title:(NSString *)title
                     andAmount:(NSString *)amount
                   andStarDate:(NSString *)startDate
                     andRepeat:(NSString *)repeat
                       andType:(NSString *)type

{
    self = [super initDataWithRowID:rowID];
    
    if (self) {
        _title = title;
        _amount = amount;
        _eventStartDate = startDate==nil?@"0000-00-00":startDate;
        _repeat = repeat;
        _type = type;
    }
    return self;
}

@end