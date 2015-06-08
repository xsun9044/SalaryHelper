//
//  ReturnData.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "ReturnData.h"

@implementation ReturnData

/*
 * The basic object for all kinds of data object returned from database
 * Have basic attributes like id
 */
- (ReturnData *)initDataWithRowID:(NSInteger)rowID

{
    self = [super init];
    
    if (self) {
        _rowID = rowID;
    }
    return self;
}

@end