//
//  CalCVCell.h
//  Vaiden
//
//  Created by Xin on 6/5/15.
//  Copyright (c) 2014 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTop;
@property (weak, nonatomic) IBOutlet UILabel *month;

@property (weak, nonatomic) IBOutlet UICollectionView *CalView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCal;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthTag;
@property (weak, nonatomic) IBOutlet UIButton *left;
@property (weak, nonatomic) IBOutlet UIButton *right;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@end
