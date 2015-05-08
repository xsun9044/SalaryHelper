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
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *dot1;
@property (weak, nonatomic) IBOutlet UIImageView *dot2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn1Height;
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
    
    [self.rightArrow changeTintColorOfUIImage:[UIImage imageNamed:@"right_arrow"] withColor:[UIColor lightGrayColor]];
    [self.dot1 changeTintColorOfUIImage:[UIImage imageNamed:@"dot_black"] withColor:[UIColor lightGrayColor]];
    [self.dot1 rotateImage90Degrees];
    [self.dot2 changeTintColorOfUIImage:[UIImage imageNamed:@"dot_black"] withColor:[UIColor lightGrayColor]];
    [self.dot2 rotateImage90Degrees];
    
    [self.btn1Height setConstant:self.view.frame.size.height/2];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.menuWidth setConstant:150.0f];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Actions
- (IBAction)setup:(UIButton *)sender
{
    NSLog(@"test");
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
