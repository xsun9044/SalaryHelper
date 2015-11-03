//
//  DetailTableViewCell.m
//  Vaiden
//
//  Created by Xin on 6/5/15.
//  Copyright (c) 2014 Xin. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIColor+ColorHelper.h"

@interface DetailTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *repeatIcon;
@end

@implementation DetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isIncome) {
        [self.icon setImage:[[UIImage imageNamed:@"coin"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.icon setTintColor:[UIColor increaseColor]];
        [self.amount setTextColor:[UIColor increaseColor]];
    } else {
        [self.icon setImage:[[UIImage imageNamed:@"cart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.icon setTintColor:[UIColor decreaseColor]];
        [self.amount setTextColor:[UIColor decreaseColor]];
    }
    
    if (self.isRepeat) {
        [self.repeatIcon setHidden:NO];
    } else {
        [self.repeatIcon setHidden:YES];
    }
}

@end
