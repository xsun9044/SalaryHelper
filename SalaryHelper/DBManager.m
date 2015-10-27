//
//  DBManager.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/17.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "DBManager.h"
#import "Event.h"

#define DB_NAME @"salaryHelper.db"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

#define DATABASE_ERROR @"databaseErr"

@implementation DBManager

+ (DBManager*)getSharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        //[sharedInstance removeDB]; // for test
    }
    return sharedInstance;
}

/*
 *
 * Create Database and All the tables in it
 * Tables: income_events - Record all the income events saved by user
 */
- (void)createDBwithCompletionHandler:(DatabaseCompletionHandler)completionHandler
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:DB_NAME]];
    NSLog(@"%@", databasePath);
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
            
            // Create income event_table
            const char *create_table_sql_stmt = "CREATE TABLE IF NOT EXISTS events(id integer PRIMARY KEY, title varchar(255), amount varchar(255) NOT NULL, start_date date NOT NULL, repeat integer DEFAULT 0, day integer DEFAULT 0, week integer DEFAULT 0, month integer DEFAULT 0, year integer DEFAULT 0, type integer DEFAULT 1)"; // type 1 means income, 2 means outlay
            if (sqlite3_exec(database, create_table_sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                completionHandler(isSuccess,
                                  [NSError errorWithDomain:DATABASE_ERROR
                                                      code:500
                                                  userInfo:[[NSDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"Failed to create table: %s",errMsg]]
                                                                                         forKeys:@[NSLocalizedDescriptionKey]]]);
            } else {
                completionHandler(isSuccess,nil);
            }
            
            sqlite3_close(database);
        } else {
            isSuccess = NO;
            completionHandler(isSuccess,
                              [NSError errorWithDomain:DATABASE_ERROR
                                                  code:500
                                              userInfo:[[NSDictionary alloc] initWithObjects:@[@"Failed to open/create database"]
                                                                                     forKeys:@[NSLocalizedDescriptionKey]]]);
        }
    } else {
        completionHandler(isSuccess,nil);
    }
}


/*
 *
 * Remove Database
 * This function only for the test purpose, will not use in release build
 */
- (BOOL)removeDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"salaryHelper.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath] != NO) {
        if (![filemgr removeItemAtPath:databasePath error:nil]) {
            isSuccess = NO;
            NSLog(@"Remove failed.");
        };
    } else {
        isSuccess = NO;
        NSLog(@"Database not exist.");
    }
    
    return isSuccess;
}


/*
 * Save income events in income event table
 */
- (void)saveIncomeEvent:(NSString*)title
                 amount:(NSString *)amount
              startDate:(NSString*)date
                 repeat:(BOOL)flag
                    day:(NSInteger)day
                   week:(NSInteger)week
                  month:(NSInteger)month
                   year:(NSInteger)year
   andCompletionHandler:(DatabaseCompletionHandler)completionHandler
{

    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO events(title,amount,start_date,repeat,day,week,month,year) VALUES (\"%@\",\"%@\",\"%@\",%d,%d,%d,%d,%d)",title,amount,date,flag,day,week,month,year];
        NSLog(@"%@", insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            completionHandler(YES, nil);
        } else {
            sqlite3_reset(statement);
            completionHandler(NO,[NSError errorWithDomain:DATABASE_ERROR
                                                     code:500
                                                 userInfo:[[NSDictionary alloc] initWithObjects:@[@"Insert failed."]
                                                                                        forKeys:@[NSLocalizedDescriptionKey]]]);
        }
        sqlite3_close (database);
    } else {
        completionHandler(NO,[NSError errorWithDomain:DATABASE_ERROR
                                             code:500
                                         userInfo:[[NSDictionary alloc] initWithObjects:@[@"Cannot open database."]
                                                                                forKeys:@[NSLocalizedDescriptionKey]]]);
    }
}

/*
 * Save outlay events in income event table
 */
- (void)saveOutlayEvent:(NSString*)title
                 amount:(NSString *)amount
              startDate:(NSString*)date
                 repeat:(BOOL)flag
                    day:(NSInteger)day
                   week:(NSInteger)week
                  month:(NSInteger)month
                   year:(NSInteger)year
   andCompletionHandler:(DatabaseCompletionHandler)completionHandler
{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO events(title,amount,start_date,repeat,day,week,month,year,type) VALUES (\"%@\",\"%@\",\"%@\",%d,%d,%d,%d,%d,%d)",title,amount,date,flag,day,week,month,year,2];
        NSLog(@"%@", insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            completionHandler(YES, nil);
        } else {
            sqlite3_reset(statement);
            completionHandler(NO,[NSError errorWithDomain:DATABASE_ERROR
                                                     code:500
                                                 userInfo:[[NSDictionary alloc] initWithObjects:@[@"Insert failed."]
                                                                                        forKeys:@[NSLocalizedDescriptionKey]]]);
        }
        sqlite3_close (database);
    } else {
        completionHandler(NO,[NSError errorWithDomain:DATABASE_ERROR
                                                 code:500
                                             userInfo:[[NSDictionary alloc] initWithObjects:@[@"Cannot open database."]
                                                                                    forKeys:@[NSLocalizedDescriptionKey]]]);
    }
}

/*
 * Retrieve income events
 * parms: date string
 *
 * Retrieve all the income events based on the date string
 */
- (void)getEventsForDate:(NSString *)dateString withCompletionHandler:(DataRetrieveCompletionHandler)completionHandler
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM events WHERE (repeat = 0 AND start_date = '%@') OR (repeat = 1 AND day > 0 AND (julianday('%@')-julianday(start_date)) %% day = 0) OR (repeat = 1 AND week > 0 AND (julianday('%@')-julianday(start_date))%%7 = 0 AND ((julianday('%@')-julianday(start_date))/7)%%week = 0 AND julianday('%@')>=julianday(start_date)) OR (repeat = 1 AND month > 0 AND strftime('%%d','%@') = strftime('%%d',start_date) AND ((strftime('%%Y','%@')-strftime('%%Y',start_date))*12 - strftime('%%m',start_date) + strftime('%%m','%@'))%%month = 0 AND julianday('%@')>=julianday(start_date)) OR (repeat = 1 AND year > 0 AND strftime('%%m','%@') = strftime('%%m',start_date) AND strftime('%%d','%@') = strftime('%%d',start_date) AND (strftime('%%Y','%@')-strftime('%%Y',start_date))%%year = 0 AND julianday('%@')>=julianday(start_date))",
                              dateString, dateString, dateString, dateString, dateString, dateString, dateString, dateString, dateString, dateString, dateString, dateString, dateString];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *rowID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *title = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *amount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *startDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *repeat = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *type = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                Event *event = [[Event alloc] initEventWithDetail:[rowID integerValue] Title:title andAmount:amount andStarDate:startDate andRepeat:repeat andType:type];
                [resultArray addObject:event];
            }
            
            sqlite3_finalize(statement);
            completionHandler(YES, resultArray, nil);
        } else {
            sqlite3_finalize(statement);
            completionHandler(NO, nil, [NSError errorWithDomain:DATABASE_ERROR
                                                           code:500
                                                       userInfo:[[NSDictionary alloc] initWithObjects:@[@"Retrieve failed."]
                                                                                              forKeys:@[NSLocalizedDescriptionKey]]]);
        }
        sqlite3_close (database);
    } else {
        completionHandler (NO, nil, [NSError errorWithDomain:DATABASE_ERROR
                                                        code:404
                                                    userInfo:[[NSDictionary alloc] initWithObjects:@[@"Cannot open database."]
                                                                                           forKeys:@[NSLocalizedDescriptionKey]]]);
    }
}

@end
