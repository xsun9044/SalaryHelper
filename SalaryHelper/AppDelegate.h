//
//  AppDelegate.h
//  SalaryHelper
//
//  Created by Turbo on 5/5/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property DBManager *dbManger;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

