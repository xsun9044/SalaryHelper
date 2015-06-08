//
//  DBManager.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/17.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


/*
 * All block used in database operations
 * Used for database creation and data insertion
 */
typedef void(^DatabaseCompletionHandler)(BOOL finished, NSError *error);

/*
 * Used for database retrieve, return with flag, result array and error
 */
typedef void(^DataRetrieveCompletionHandler)(BOOL finished, NSArray *result, NSError *error);

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

- (void)getEventsForDate:(NSString *)dateString withCompletionHandler:(DataRetrieveCompletionHandler)completionHandler;

@end
