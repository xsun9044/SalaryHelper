//
//  DBManager.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/17.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "DBManager.h"

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
            const char *create_table_sql_stmt = "CREATE TABLE IF NOT EXISTS income_events(id integer PRIMARY KEY, title varchar(255), amount varchar(255) NOT NULL, start_date date NOT NULL, repeat integer DEFAULT 0, day integer DEFAULT 0, week integer DEFAULT 0, month integer DEFAULT 0, year integer DEFAULT 0)";
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


// Remove database only for test purpose
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
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO income_events(title,amount,start_date,repeat,day,week,month,year) VALUES (\"%@\",\"%@\",\"%@\",%d,%d,%d,%d,%d)",title,amount,date,flag,day,week,month,year];
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

- (NSArray*)getEventsForDate:(NSString *)dateString
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
#warning TODO: NEED TEST
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM income_events WHERE (repeat = 0 AND start_date = '2015-06-01') OR (SELECT * FROM income_events WHERE repeat = 1 AND day > 0 AND (julianday('2015-06-03')-julianday(start_date)) %% day = 0) OR (SELECT * FROM income_events WHERE repeat = 1 AND week > 0 AND (julianday('2015-06-03')-julianday(start_date)) %% day = 0)", dateString];
        
        // week
        NSString *querySQL = @"SELECT * FROM income_events WHERE repeat = 1 AND week > 0 AND (julianday('2015-06-12')-julianday('2015-05-29'))%7 = 0 AND ((julianday('2015-06-12')-julianday('2015-05-29'))/7)%week = 0";
        
        // month
        querySQL = @"SELECT * FROM income_events WHERE repeat = 1 AND month > 0 AND strftime('%d','2015-06-12') = strftime('%d','2015-05-29') AND (strftime('%Y','2015-06-12')-strftime('%Y','2015-05-29'))*12+strftime('%m','2015-05-29')%month = 0";
        
        // year
        querySQL = @"SELECT * FROM income_events WHERE repeat = 1 AND year > 0 AND strftime('%m','2015-06-12') = strftime('%m','2015-05-29') AND strftime('%d','2015-06-12') = strftime('%d','2015-05-29') AND (strftime('%Y','2015-06-12')-strftime('%Y','2015-05-29'))%year = 0";
        
        NSLog(@"%@", querySQL);
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *rowID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:rowID];
                /*NSString *title = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:title];
                NSString *amount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:amount];
                NSString *start_date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:start_date];*/
                //;
            }
            
            sqlite3_reset(statement);
            return resultArray;
        }
    }
    return nil;
}

@end
