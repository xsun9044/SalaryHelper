//
//  DayObject.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "DayObject.h"
#import "AppDelegate.h"

@interface DayObject()
@property (nonatomic, strong) DBManager *dbManger; // Required for database operations
@end

@implementation DayObject

- (DBManager *)dbManger
{
    if (!_dbManger) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _dbManger = delegate.dbManger;
    }
    
    return _dbManger;
}


- (DayObject *)initDataWithDay:(NSString *)day InThisMonth:(BOOL)flag

{
    self = [super init];
    
    if (self) {
        _day = day;
        _inThisMonth = flag;
    }
    return self;
}

- (DayObject *)initDataWithDay:(NSString *)day InThisMonth:(BOOL)flag andFullDate:(NSString *)dateString

{
    self = [super init];
    
    if (self) {
        _day = day;
        _inThisMonth = flag;
        _fullDate = dateString;
        
        [self getEventForDay];
    }
    return self;
}

- (void)getEventForDay
{
    [self.dbManger getEventsForDate:self.fullDate
              withCompletionHandler:^(BOOL finished, NSArray *result, NSError *error) {
                  if (finished) {
                      if (result.count > 0) {
                          self.incomeEvents = result;
                      }
                  }
              }];
}

@end