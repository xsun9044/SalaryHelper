//
//  DayCVCell.h
//  Vaiden
//
//  Created by Xin on 6/5/15.
//  Copyright (c) 2014 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayCVCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayWidth;
@property (weak, nonatomic) IBOutlet UIView *cover;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverHeight;

@property (weak, nonatomic) IBOutlet UIView *increaseBar;
@property (weak, nonatomic) IBOutlet UIView *decreaseBar;
@end
