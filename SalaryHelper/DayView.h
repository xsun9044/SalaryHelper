//
//  ReturnData.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/6/6.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReturnData : NSObject

@property (nonatomic) NSInteger rowID;

- (ReturnData *)initDataWithRowID:(NSInteger)rowID;

@end
