//
//  MenuVC.m
//  SalaryHelper
//
//  Created by Xin on 5/5/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "MenuVC.h"
#import "UIImageView+imageViewHelper.h"
#import "UIView+ViewHelper.h"
#import "PreferencesHelper.h"

@interface MenuVC ()
@property (nonatomic, strong) PreferencesHelper * preferences;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagePaddingTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuPaddingTop;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (strong, nonatomic) UIButton *currentLight;
@end

@implementation MenuVC

- (PreferencesHelper *)preferences
{
    if (!_preferences) _preferences = [[PreferencesHelper alloc] init];
    return _preferences;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger version = [[UIDevice currentDevice].systemVersion integerValue];
    if (version == 8) {
        [self.backgroundImageView setHidden:NO];
        [self.backgroundImageView setImage:self.backgroundImage];
        [self.backgroundImageView setContentMode:UIViewContentModeTop];
    }
    
    [self.icon1 changeTintColorOfUIImage:[UIImage imageNamed:@"money"] withColor:[UIColor whiteColor]];
    [self.icon2 changeTintColorOfUIImage:[UIImage imageNamed:@"cash"] withColor:[UIColor whiteColor]];
    [self.icon3 changeTintColorOfUIImage:[UIImage imageNamed:@"graph"] withColor:[UIColor whiteColor]];
    
    [self.btn1 makeRoundedCornerWithoutBorder:4.0f];
    [self.btn2 makeRoundedCornerWithoutBorder:4.0f];
    [self.btn3 makeRoundedCornerWithoutBorder:4.0f];
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.menuView addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.imagePaddingTop setConstant:0];
    [self.menuPaddingTop setConstant:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.preferences getSumbitSuccessFlag]) { // If save done, back to calendar instead of menu
        [self.menuHeight setConstant:0.0f];
        [self.imagePaddingTop setConstant:0];
        [UIView animateWithDuration:0.2f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                [self.preferences resetReturnFromSubmitSuccess];
            }];
        }];
    } else {
        [self.menuHeight setConstant:50];
        [self.imagePaddingTop setConstant:50];
        [UIView animateWithDuration:0.2f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Actions
#define ADD_INCOME 0
#define ADD_OUTLAY 1
#define CHECK_HISTORY 2
- (IBAction)actions:(UIButton *)sender
{
    if (self.currentLight != nil) {
        [self.currentLight setBackgroundColor:[UIColor clearColor]];
    }
    sender.backgroundColor = [UIColor colorWithRed:99/255.0 green:172/255.0 blue:233/255.0 alpha:1.0];
    self.currentLight = sender;
    
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
        [self.menuHeight setConstant:0.0f];
        [self.imagePaddingTop setConstant:0.0f];
        [UIView animateWithDuration:0.2f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)gesture
{
    [self.menuHeight setConstant:0.0f];
    [self.imagePaddingTop setConstant:0.0f];
    [UIView animateWithDuration:0.2f animations:^{
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
