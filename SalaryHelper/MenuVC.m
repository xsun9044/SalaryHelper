//
//  MenuVC.m
//  SalaryHelper
//
//  Created by Xin on 5/5/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "MenuVC.h"
#import "UIImageView+imageViewHelper.h"

@interface MenuVC ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidth;
@property (weak, nonatomic) IBOutlet UIButton *setupButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@end

@implementation MenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger version = [[UIDevice currentDevice].systemVersion integerValue];
    if (version == 8) {
        [self.backgroundImageView setHidden:NO];
        [self.backgroundImageView setImage:self.backgroundImage];
        [self.backgroundImageView setContentMode:UIViewContentModeTop];
    }
    
    [self.rightArrow changeTintColorOfUIImage:[UIImage imageNamed:@"right_arrow"] withColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.menuWidth setConstant:150.0f];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
