//
//  DetailTableViewCell.h
//  Vaiden
//
//  Created by Xin on 6/5/15.
//  Copyright (c) 2014 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isIncome;
@property (nonatomic, assign) BOOL isRepeat;

@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
