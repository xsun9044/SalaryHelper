//
//  AddTVC.h
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/13.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddTVC : UITableViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic) NSInteger type;

@end
