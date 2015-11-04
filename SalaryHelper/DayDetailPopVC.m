//
//  DayDetailPopVC.m
//  SalaryHelper
//
//  Created by Xin Sun on 10/3/15.
//  Copyright © 2015 Xin. All rights reserved.
//

#import "DayDetailPopVC.h"
#import "UIColor+ColorHelper.h"
#import "MenuVC.h"
#import "Event.h"
#import "DetailTableViewCell.h"
#import "PreferencesHelper.h"

@interface DayDetailPopVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *movingImageView;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITableView *detailTableView;

@property (atomic) BOOL animationLock;

@property (nonatomic, assign) CGFloat fullHeight;
@property (nonatomic, assign) CGFloat fullWidth;

@end

@implementation DayDetailPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImageView.image = self.bgImage;
    self.fullHeight = [[UIScreen mainScreen] bounds].size.height;
    self.fullWidth = [[UIScreen mainScreen] bounds].size.width;
    
    [self buildView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.view addGestureRecognizer:longPressGesture];
    
}

- (void)buildView
{
    UIImage *newImage;
    if (self.dayView.frame.origin.x >= 4*self.dayView.frame.size.width) {
        newImage = [self croppedImage:self.bgImage InRect:CGRectMake(0, self.fullHeight/5-21, self.dayView.frame.origin.x-1, self.fullHeight-(self.fullHeight/5-21))];
    } else {
        newImage = [self croppedImage:self.bgImage InRect:CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width+1, self.fullHeight/5-21, self.fullWidth-(self.dayView.frame.origin.x+self.dayView.frame.size.width), self.fullHeight-(self.fullHeight/5-21))];
    }
    self.movingImageView = [[UIImageView alloc] initWithImage:newImage];
    if (self.dayView.frame.origin.x >= 4*self.dayView.frame.size.width) {
        [self.movingImageView setFrame:CGRectMake(0, self.fullHeight/5-21, self.dayView.frame.origin.x, self.fullHeight-(self.fullHeight/5-21))];
    } else {
        [self.movingImageView setFrame:CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width, self.fullHeight/5-21, self.fullWidth-(self.dayView.frame.origin.x+self.dayView.frame.size.width), self.fullHeight-(self.fullHeight/5-21))];
    }
    [self.view addSubview:self.movingImageView];
    [self.view bringSubviewToFront:self.movingImageView];
    
    [self buildDetailView];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(((self.fullWidth-6)/7 * 6) + ((self.fullWidth-6)/7/2 - 13), (self.fullHeight / 5 - 21)/2 - 13, 26, 26)];
    [menuButton setBackgroundColor:[UIColor clearColor]];
    [menuButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
}

- (void)buildDetailView
{
    if (self.dayView.frame.origin.x >= 4*self.dayView.frame.size.width) {
        self.detailView = [[UIView alloc] initWithFrame:CGRectMake(self.dayView.frame.origin.x, self.fullHeight/5-21, 0, self.fullHeight-(self.fullHeight/5-21))];
    } else {
        self.detailView = [[UIView alloc] initWithFrame:CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width, self.fullHeight/5-21, 0, self.fullHeight-(self.fullHeight/5-21))];
    }
    [self.detailView setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]];
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 21)];
    [self.topView setBackgroundColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.89]];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 3*self.dayView.frame.size.width, 21)];
    self.label.text = @"Detail";
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f]];
    [self.label setTextColor:[UIColor themeBlueColor]];
    self.label.alpha = 0;
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self.topView addSubview:self.label];
    [self.detailView addSubview:self.topView];
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, 3*self.dayView.frame.size.width, self.detailView.frame.size.height-self.topView.frame.size.height) style:UITableViewStylePlain];
    [self.detailTableView setBackgroundColor:[UIColor clearColor]];
    //[self.detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.detailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.detailTableView setBounces:NO];
    self.detailTableView.showsVerticalScrollIndicator = NO;
    self.detailTableView.alpha = 0;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    
    [self.detailView addSubview:self.detailTableView];
    [self.detailView bringSubviewToFront:self.detailView];
    
    [self.view addSubview:self.detailView];
    [self.view bringSubviewToFront:self.detailView];
}

- (IBAction)setting:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"menu_segue" sender:sender];
}

#define rad(angle) ((angle) / 180.0 * M_PI)
- (CGAffineTransform)orientationTransformedRectOfImage:(UIImage *)img
{
    CGAffineTransform rectTransform;
    switch (img.imageOrientation)
    {	
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}


- (UIImage *)croppedImage:(UIImage*)orignialImage InRect:(CGRect)visibleRect{
    //transform visible rect to image orientation
    CGAffineTransform rectTransform = [self orientationTransformedRectOfImage:orignialImage];
    visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);
    
    //crop image
    CGImageRef imageRef = CGImageCreateWithImageInRect([orignialImage CGImage], visibleRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:orignialImage.scale orientation:orignialImage.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([[PreferencesHelper sharedManager] getSumbitSuccessFlag]) {
        if (self.animationLock) {
            return;
        }
        self.detailTableView.alpha = 0;
        self.animationLock = YES;
        [UIView animateWithDuration:0.3f animations:^{
            self.label.alpha = 0;
            if (self.dayView.frame.origin.x >= 4*self.dayView.frame.size.width) {
                self.detailView.frame = CGRectMake(self.dayView.frame.origin.x, self.fullHeight/5-21, 0, self.fullHeight-(self.fullHeight/5-21));
                self.topView.frame = CGRectMake(0, 0, 0, 21);
                [self.movingImageView setFrame:CGRectMake(0, self.fullHeight/5-21, self.dayView.frame.origin.x, self.fullHeight-(self.fullHeight/5-21))];
            } else {
                self.detailView.frame = CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width, self.fullHeight/5-21, 0, self.fullHeight-(self.fullHeight/5-21));
                self.topView.frame = CGRectMake(0, 0, 0, 21);
                self.movingImageView.frame = CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width, self.fullHeight/5-21, self.fullWidth-(self.dayView.frame.origin.x+self.dayView.frame.size.width), self.fullHeight-(self.fullHeight/5-21));
            }
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.label.alpha = 1;
            if (self.dayView.frame.origin.x >= 4*self.dayView.frame.size.width) {
                self.detailView.frame = CGRectMake(self.dayView.frame.origin.x-3*self.dayView.frame.size.width, self.fullHeight/5-21, 3*self.dayView.frame.size.width, self.fullHeight-(self.fullHeight/5-21));
                self.topView.frame = CGRectMake(0, 0, 3*self.dayView.frame.size.width, 21);
                self.movingImageView.frame = CGRectMake(0-3*self.dayView.frame.size.width, self.fullHeight/5-21, self.dayView.frame.origin.x, self.fullHeight-(self.fullHeight/5-21));
            } else {
                self.detailView.frame = CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width, self.fullHeight/5-21, 3*self.dayView.frame.size.width, self.fullHeight-(self.fullHeight/5-21));
                self.topView.frame = CGRectMake(0, 0, 3*self.dayView.frame.size.width, 21);
                self.movingImageView.frame = CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width+3*self.dayView.frame.size.width, self.fullHeight/5-21, self.fullWidth-(self.dayView.frame.origin.x+self.dayView.frame.size.width), self.fullHeight-(self.fullHeight/5-21));
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3f animations:^{
                self.detailTableView.alpha = 1.0;
            }];
        }];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)tapHandler:(UIGestureRecognizer *)gesture
{
    if (self.animationLock) {
        return;
    }
    
    CGPoint touchPoint = [gesture locationInView:self.view];
    if ((self.dayView.frame.origin.x >= 4*self.dayView.frame.size.width && (touchPoint.x < self.dayView.frame.origin.x-3*self.dayView.frame.size.width || touchPoint.x > self.dayView.frame.origin.x))
        || (self.dayView.frame.origin.x < 4*self.dayView.frame.size.width && (touchPoint.x <= self.dayView.frame.origin.x+self.dayView.frame.size.width || touchPoint.x >= self.dayView.frame.origin.x+self.dayView.frame.size.width+3*self.dayView.frame.size.width))) {
        self.detailTableView.alpha = 0;
        self.animationLock = YES;
        [UIView animateWithDuration:0.3f animations:^{
            self.label.alpha = 0;
            if (self.dayView.frame.origin.x >= 4*self.dayView.frame.size.width) {
                self.detailView.frame = CGRectMake(self.dayView.frame.origin.x, self.fullHeight/5-21, 0, self.fullHeight-(self.fullHeight/5-21));
                self.topView.frame = CGRectMake(0, 0, 0, 21);
                [self.movingImageView setFrame:CGRectMake(0, self.fullHeight/5-21, self.dayView.frame.origin.x, self.fullHeight-(self.fullHeight/5-21))];
            } else {
                self.detailView.frame = CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width, self.fullHeight/5-21, 0, self.fullHeight-(self.fullHeight/5-21));
                self.topView.frame = CGRectMake(0, 0, 0, 21);
                self.movingImageView.frame = CGRectMake(self.dayView.frame.origin.x+self.dayView.frame.size.width, self.fullHeight/5-21, self.fullWidth-(self.dayView.frame.origin.x+self.dayView.frame.size.width), self.fullHeight-(self.fullHeight/5-21));
            }
        } completion:^(BOOL finished) {
            if (touchPoint.x >= self.dayView.frame.origin.x && touchPoint.x <= self.dayView.frame.origin.x+self.dayView.frame.size.width && touchPoint.y>=self.dayView.frame.origin.y+self.fullHeight/5 && touchPoint.y <= self.dayView.frame.origin.y+self.fullHeight/5+self.dayView.frame.size.height) { // inside the checked view, close detail
                [self dismissViewControllerAnimated:NO completion:nil];
            } else { // outside the checked view, close current and open new;
                if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
                    [self.delegate openOtherView:[self pointInSuperView:touchPoint]];
                } else {
                    [self.delegate pickOtherDay:[self pointInSuperView:touchPoint]];
                }
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }];
    }
}

- (CGPoint)pointInSuperView:(CGPoint)touchPoint
{
    if (self.dayView.frame.origin.x >= 4*self.dayView.frame.size.width) {
        if (touchPoint.x < self.dayView.frame.origin.x) {
            return CGPointMake(touchPoint.x+3*self.dayView.frame.size.width, touchPoint.y-self.fullHeight/5);
        } else {
            return CGPointMake(touchPoint.x, touchPoint.y-self.fullHeight/5);
        }
    } else {
        if (touchPoint.x > self.dayView.frame.origin.x+self.dayView.frame.size.width) {
            return CGPointMake(touchPoint.x-3*self.dayView.frame.size.width, touchPoint.y-self.fullHeight/5);
        } else {
            return CGPointMake(touchPoint.x, touchPoint.y-self.fullHeight/5);
        }
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detail_cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"detail_cell"];
        cell = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detail_cell"];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    Event *event = (Event *)[self.events objectAtIndex:indexPath.row];
    if ([event.type isEqualToString:@"1"]) {
        cell.amount.text = [NSString stringWithFormat:@"$%@", event.amount];
        cell.isIncome = YES;
        cell.isRepeat = [event.repeat boolValue];
    } else {
        cell.amount.text = [NSString stringWithFormat:@"$%@", event.amount];
        cell.isIncome = NO;
        cell.isRepeat = [event.repeat boolValue];
    }
    
    cell.content.text = event.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"menu_segue"]) {
        MenuVC *controller = (MenuVC *)segue.destinationViewController;
        controller.isDetailPage = YES;
        // If it's under IOS 8, then take the screenshot
        NSInteger version = [[UIDevice currentDevice].systemVersion integerValue];
        if (version >= 8) {
            UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, self.view.opaque, 0.0);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage * sc = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            controller.backgroundImage = sc;
        }
    }
}
@end