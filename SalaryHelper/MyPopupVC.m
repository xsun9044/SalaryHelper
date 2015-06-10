//
//  MyPopupVC.m
//  SalaryHelper
//
//  Created by Xin on 5/5/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "MyPopupVC.h"
#import "UIView+ViewHelper.h"

@interface MyPopupVC ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *outterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *flashingView;
@end

@implementation MyPopupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger version = [[UIDevice currentDevice].systemVersion integerValue];
    if (version == 8) {
        [self.backgroundImageView setHidden:NO];
        [self.backgroundImageView setImage:self.backgroundImage];
        [self.backgroundImageView setContentMode:UIViewContentModeTop];
    }
    
    [self.outterView makeRoundedCornerWithoutBorder:7.0f]
    ;
    self.outterView.alpha = 0;
    
    self.titleLabel.text = self.header;
    self.content.text = self.contentString;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.outterView.alpha = 1;
    }];
}

#pragma mark - Actions
- (IBAction)ok:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.outterView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.view];
    BOOL inside = NO;
    
    for (UIView *subView in [self.view subviews]) {
        if(CGRectContainsPoint(self.outterView.frame, touchPoint) && [subView isKindOfClass:[UIView class]]) {
            inside = YES;
            break;
        }
    }
    
    if(!inside){
        self.flashingView.hidden = NO;
        self.flashingView.alpha = 0.8;
        [UIView animateWithDuration:0.2f animations:^{
            [UIView setAnimationRepeatCount:2];
            self.flashingView.alpha = 0;
        } completion:^(BOOL finished) {
            self.flashingView.hidden = YES;
        }];
    }
}

@end
