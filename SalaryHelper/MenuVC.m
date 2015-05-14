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
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *popView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
/*
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popLeftPadding;
 */

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
    
    [self.view1 setHidden:YES];
    [self.view2 setHidden:YES];
    [self.view3 setHidden:YES];
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.menuView addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    /*
    // Set frame for popup window
    [self.popHeight setConstant:[[UIScreen mainScreen] bounds].size.height - 40];
    [self.popWidth setConstant:[[UIScreen mainScreen] bounds].size.width - 16 - 150 + 32];
    [self.popLeftPadding setConstant: [[UIScreen mainScreen] bounds].size.width];
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.menuWidth setConstant:150.0f];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view1 setHidden:NO];
        [self.view2 setHidden:NO];
        [self.view3 setHidden:NO];
    }];
}

#pragma mark - Actions
#define ADD_INCOME 0
#define ADD_OUTLAY 1
#define CHECK_HISTORY 2
- (IBAction)actions:(UIButton *)sender
{
    if (sender.tag == ADD_INCOME) {
        [self performSegueWithIdentifier:@"add_segue" sender:sender];
    } else if (sender.tag == ADD_OUTLAY) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"2";
        alert.message = @"2";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"3";
        alert.message = @"3";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }
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
        [self.view1 setHidden:YES];
        [self.view2 setHidden:YES];
        [self.view3 setHidden:YES];
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
    [self.view1 setHidden:YES];
    [self.view2 setHidden:YES];
    [self.view3 setHidden:YES];
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
