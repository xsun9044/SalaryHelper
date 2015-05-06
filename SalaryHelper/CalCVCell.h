//
//  BuyVoteCVCell.h
//  Vaiden
//
//  Created by Turbo on 8/4/14.
//  Copyright (c) 2014 James Chung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyVoteCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *context;

@end
