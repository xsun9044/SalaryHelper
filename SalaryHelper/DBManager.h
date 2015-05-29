//
//  DBManager.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/17.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef void(^DatabaseCompletionHandler)(BOOL finished, NSError *error);

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+ (DBManager*)getSharedInstance;

- (void)createDBwithCompletionHandler:(DatabaseCompletionHandler)completionHandler;

- (void)saveIncomeEvent:(NSString*)title
                 amount:(NSString *)amount
              startDate:(NSString*)date
                 repeat:(BOOL)flag
                    day:(NSInteger)day
                   week:(NSInteger)week
                  month:(NSInteger)month
                   year:(NSInteger)year
   andCompletionHandler:(DatabaseCompletionHandler)completionHandler;

- (NSArray*)retrieveDataTestFunction;

@end
