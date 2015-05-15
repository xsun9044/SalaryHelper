//
//  RepeatTVC.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/15.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepeatDelegate <NSObject>
- (void)getRepeatType:(NSString *)typeName withNumber:(NSInteger)num;
@end

@interface RepeatTVC : UITableViewController
@property (nonatomic, weak) id <RepeatDelegate>delegate;
@property (nonatomic) NSInteger row;
@property (nonatomic, strong) NSString *repeatString;
@end
