//
//  DetailTableViewCell.m
//  Vaiden
//
//  Created by Xin on 6/5/15.
//  Copyright (c) 2014 Xin. All rights reserved.
//

#import "DetailTableViewCell.h"

@interface DetailTableViewCell()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *amount;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *repeatIcon;

@end

@implementation DetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

@end
