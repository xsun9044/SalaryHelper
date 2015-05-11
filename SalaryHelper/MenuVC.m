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
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *dot1;
@property (weak, nonatomic) IBOutlet UIImageView *dot2;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;
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
    [self.icon1 changeTintColorOfUIImage:[UIImage imageNamed:@"money"] withColor:[UIColor whiteColor]];
    [self.icon2 changeTintColorOfUIImage:[UIImage imageNamed:@"cash"] withColor:[UIColor whiteColor]];
    [self.icon3 changeTintColorOfUIImage:[UIImage imageNamed:@"graph"] withColor:[UIColor whiteColor]];
    
    [self.btnHeight setConstant:self.view.frame.size.height/3];
    [self.btnWidth setConstant:140.0f];
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.menuView addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
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

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.view];
    BOOL inside = NO;
    
    for (UIView *subView in [self.view subviews]) {
        if(CGRectContainsPoint(self.menuView.frame, touchPoint) && [subView isKindOfClass:[UIView class]]) {
            inside = YES;
            break;
        }
    }
    
    if(!inside){
        // Dismiss modal view
        [self.menuWidth setConstant:0.0f];
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)gesture
{
    [self.menuWidth setConstant:0.0f];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
