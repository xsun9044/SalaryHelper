//
//  InputTVCell.h
//  Vaiden
//
//  Created by Xin on 5/14/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) IBOutlet UIPickerView *picker2;

@property (weak, nonatomic) IBOutlet UITextField *input1;
@property (weak, nonatomic) IBOutlet UITextField *input2;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@end
