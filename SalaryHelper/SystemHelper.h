//
//  SystemHelper.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/17.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#ifndef SalaryHelper_SystemHelper_h
#define SalaryHelper_SystemHelper_h

// detect if system verison is above a specfic version
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 200 years， don't ask me why
#define startDate @"1914-01-01 00:00:00"
#define endDate @"2113-12-31 23:59:59"

#endif


