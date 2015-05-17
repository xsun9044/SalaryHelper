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

@implementation DBManager

+ (DBManager*)getSharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        //[sharedInstance removeDB];
    }
    return sharedInstance;
}

- (BOOL)createDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:DB_NAME]];
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
                
#warning TODO: DEBUG NOTIFICATIONS
                NSLog(@"Failed to create table: %s", errMsg);
            }
            
            sqlite3_close(database);
            
            return  isSuccess;
        } else {
            isSuccess = NO;
            
#warning TODO: DEBUG NOTIFICATIONS
            NSLog(@"Failed to open/create database");
        }
    } else {
        NSLog(@"Exists");
    }
    
    return isSuccess;
}

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

- (BOOL)saveIncomeEvent:(NSString*)title
                 amount:(NSString *)amount
              startDate:(NSString*)date
                 repeat:(BOOL)flag
                    day:(NSInteger)day
                   week:(NSInteger)week
                  month:(NSInteger)month
                   year:(NSInteger)year
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO income_events(title,amount,start_date,repeat,day,week,month,year) VALUES (\"%@\",\"%@\",\"%@\",%d,%d,%d,%d,%d)",title,amount,date,flag,day,week,month,year];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            return YES;
        } else {
            NSLog(@"Insert failed.");
            sqlite3_reset(statement);
            return NO;
        }
    }
    
    NSLog(@"Cannot open database.");
    
    return NO;
}

@end
