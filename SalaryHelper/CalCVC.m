//
//  CalCVC.m
//  SalaryHelper
//
//  Created by Xin on 5/5/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import "CalCVC.h"
#import "CalCVCell.h"
#import "NSDate+DateHelper.h"
#import "DayCVCell.h"
#import "MenuVC.h"
#import "UIImageView+imageViewHelper.h"
#import "SystemHelper.h"
#import "CalendarObject.h"
#import "DayObject.h"
#import "DayView.h"
#import "UIColor+ColorHelper.h"
#import "Event.h"

@interface CalCVC ()
@property (nonatomic) CGFloat fullHeight;
@property (nonatomic) CGFloat fullWidth;
@property (nonatomic) CGFloat heightBottom;

@property (nonatomic) NSInteger currentCheckingMonth;
@property (nonatomic) NSInteger willDisplayPosition;
@property (nonatomic) NSInteger monthForToday;
@property (nonatomic) NSInteger lastSelectionMonth;

@property (nonatomic) BOOL checkToday;
@property (nonatomic) BOOL shouldShowCover;

@property (nonatomic) BOOL didStop;
@property (nonatomic) BOOL didDisplayCell;

@property (nonatomic, strong) UIView *todayView;
@property (nonatomic, strong) UIView *lastSelect;

@property (nonatomic, strong) CalendarObject *cal;
@property (nonatomic, strong) CalendarObject *targetCal;
@property (nonatomic, strong) CalendarObject *todayObject;

@property (nonatomic, strong) UIView *menuBtnView;

@property (nonatomic, strong) NSMutableDictionary *test;
@end

@implementation CalCVC
#define OUTTER 1
#define INNER 2
#define INIT_CHECKING_MONTH -1

- (NSMutableDictionary *)test
{
    if (_test) {
        _test = [[NSMutableDictionary alloc] init];
    }
    return _test;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.tabBarController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.fullHeight = [[UIScreen mainScreen] bounds].size.height;
    self.fullWidth = [[UIScreen mainScreen] bounds].size.width;
    
    self.heightBottom = 4*_fullHeight / 5;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.currentCheckingMonth = INIT_CHECKING_MONTH;
    self.shouldShowCover = YES;
    self.didStop = YES;
    self.didDisplayCell = YES;
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.menuBtnView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-6)/7 * 6, 0, [UIScreen mainScreen].bounds.size.width, _fullHeight / 5 - 21)];
    [self.menuBtnView setBackgroundColor:[UIColor clearColor]];
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-6)/7/2 - 13, (_fullHeight / 5 - 21)/2 - 13, 26, 26)];
    [menuButton setImage:[[UIImage imageNamed:@"piggy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [menuButton.imageView setTintColor:[UIColor whiteColor]];
    [menuButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuBtnView addSubview:menuButton];
    [self.navigationController.view addSubview:self.menuBtnView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger months;
    if (self.currentCheckingMonth == INIT_CHECKING_MONTH) {
        months = [NSDate monthsBetweenDate:[NSDate getDateTimeFromStringInUTC:startDate] andDate:[NSDate getDateTimeFromStringInUTC:[NSDate getCurrentDateTime]]];
        self.currentCheckingMonth = months;
        self.monthForToday = months;
    } else {
        months = self.currentCheckingMonth;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:(months) inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    if (self.cal == nil) {
        self.cal = [[CalendarObject alloc] initThereMonthsWithCurrentMonthIndexRow:months];
        self.todayObject = self.cal;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [NSDate monthsBetweenDate:[NSDate getDateTimeFromStringInUTC:startDate] andDate:[NSDate getDateTimeFromStringInUTC:endDate]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarObject *data;
#warning NEED TEST IF IT WILL CRASH WHEN SWITCH PAGES RAPIDLY IN CELL PHONE CPU SPEED
    if (self.cal.currentMonthIndex == indexPath.row || self.checkToday) {
        data = self.cal;
    } else if (self.cal.currentMonthIndex > indexPath.row) {
        data = self.cal.priorMonth;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Do background work
            self.targetCal = [[CalendarObject alloc] initDataWhenMoveLeft:self.cal.priorMonth and:self.cal];
        });
    } else {
        data = self.cal.nextMonth;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Do background work
            self.targetCal = [[CalendarObject alloc] initDataWhenMoveRight:self.cal.nextMonth and:self.cal];
        });
    }
    
    self.willDisplayPosition = indexPath.row;
    
    CalCVCell *cell = (CalCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"month_cell" forIndexPath:indexPath];
    
    [cell.heightTop setConstant:_fullHeight / 5];
    cell.widthTag.constant = (_fullWidth-6)/7;
    
    if (self.monthForToday == indexPath.row) {
        cell.todayBtn.hidden = YES;
    } else {
        cell.todayBtn.hidden = NO;
    }
    
    cell.month.text = [NSString stringWithFormat:@"%@  %ld", data.monthName, (long)data.year];
    
    if (data.hasToday) {
        if (data.todayWeekDay % 7 == 2) {
            [cell.monday setTextColor:[UIColor themeBlueColor]];
            [cell.monday setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        } else if (data.todayWeekDay % 7 == 3) {
            [cell.tuesday setTextColor:[UIColor themeBlueColor]];
            [cell.tuesday setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        } else if (data.todayWeekDay % 7 == 4) {
            [cell.wednesday setTextColor:[UIColor themeBlueColor]];
            [cell.wednesday setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        } else if (data.todayWeekDay % 7 == 5) {
            [cell.thursday setTextColor:[UIColor themeBlueColor]];
            [cell.thursday setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        } else if (data.todayWeekDay % 7 == 6) {
            [cell.friday setTextColor:[UIColor themeBlueColor]];
            [cell.friday setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        } else if (data.todayWeekDay % 7 == 0) {
            [cell.saturday setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        } else if (data.todayWeekDay % 7 == 1) {
            [cell.sunday setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        }
    } else {
        [cell.monday setTextColor:[UIColor whiteColor]];
        [cell.monday setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        [cell.thursday setTextColor:[UIColor whiteColor]];
        [cell.thursday setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        [cell.wednesday setTextColor:[UIColor whiteColor]];
        [cell.wednesday setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        [cell.tuesday setTextColor:[UIColor whiteColor]];
        [cell.tuesday setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        [cell.friday setTextColor:[UIColor whiteColor]];
        [cell.friday setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        [cell.sunday setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        [cell.saturday setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    }
    
    if (self.shouldShowCover) {
        self.shouldShowCover = NO;
        cell.monthCover.hidden = YES;
    } else {
        cell.monthCover.hidden = NO;
        cell.monthCover.alpha = 1;
        cell.monthCover.layer.borderWidth = 0.25f;
        cell.monthCover.layer.borderColor = [[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.85] CGColor];
        cell.monthTitle.text = [NSString stringWithFormat:@"%@ %d", data.monthName, data.year];
    }
    
    if (self.checkToday) {
        [UIView animateWithDuration:0.5f animations:^{
            cell.month.alpha = 1;
        }];
    }
    self.checkToday = NO;
    
    // Load day
    [[cell.bottomView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=1; i<=data.daysArray.count; i++) {
        DayObject *day = [data.daysArray objectAtIndex:i-1];
        DayView *dayView = [[DayView alloc] initDayViewWithFrame:
                        CGRectMake(i%7-1==-1?6*(_fullWidth/7):(i%7-1)*(_fullWidth/7),
                                   (i%7 == 0?(i/7 - 1):i/7)*self.heightBottom/(data.daysArray.count/7),
                                   _fullWidth/7,
                                   self.heightBottom/(data.daysArray.count/7))];
        if (i%7 == 1 || i%7 == 0) {
            [dayView setWeekendDayTitle];
        }
        
        [dayView setDayText:day.day hideCover:day.inThisMonth isToday:day.isToday willShowIncomeBar:day.incomeEvents.count>0?YES:NO willShowOutlayBar:NO];
#warning NEED TEST PERFORMANCE IN IPHONE 4
        if (day.incomeEvents.count > 0) {
            CGFloat totalAmount = 0;
            for (Event *event in day.incomeEvents) {
                totalAmount += (CGFloat)[event.amount doubleValue];
            }
            
            [dayView setIncomeTitle:[NSString stringWithFormat:@"+ $%.2f", totalAmount]];
        }
        
        if (day.isToday) {
            self.todayView = dayView;
        }
        
        [cell.bottomView addSubview:dayView];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_fullWidth, _fullHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.willDisplayPosition != indexPath.row && !self.checkToday) {
        self.currentCheckingMonth = self.willDisplayPosition;
        self.cal = self.targetCal;
    }
    self.didDisplayCell = YES;
    if (self.didStop) { // scroll already stops
        CalCVCell *cell = (CalCVCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentCheckingMonth inSection:0]];
        [UIView animateWithDuration:0.5 animations:^{
            cell.monthCover.alpha = 0;
        } completion:^(BOOL finished) {
            cell.monthCover.hidden = YES;
            [self.collectionView setUserInteractionEnabled:YES];
        }];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.didStop) {
        [self.collectionView setUserInteractionEnabled:NO];
        self.didStop = NO;
        self.didDisplayCell = NO;
        CalCVCell *cell = (CalCVCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentCheckingMonth inSection:0]];
        cell.monthCover.hidden = NO;
        cell.monthCover.alpha = 0;
        cell.monthCover.layer.borderWidth = 0.25f;
        cell.monthCover.layer.borderColor = [[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.85] CGColor];
        cell.monthTitle.text = [NSString stringWithFormat:@"%@ %d", self.cal.monthName, self.cal.year];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.menuBtnView.alpha = 0;
            cell.monthCover.alpha = 1;
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.didStop = YES;
    if (self.didDisplayCell) { // already change current cell to next cell
        CalCVCell *cell = (CalCVCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentCheckingMonth inSection:0]];
        [UIView animateWithDuration:0.5f animations:^{
            cell.monthCover.alpha = 0;
            self.menuBtnView.alpha = 1;
        } completion:^(BOOL finished) {
            cell.monthCover.hidden = YES;
            [self.collectionView setUserInteractionEnabled:YES];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.menuBtnView.alpha = 1;
        }];
    }
}

#pragma mark - Actions
- (IBAction)checkToday:(UIButton *)sender
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.currentCheckingMonth inSection:0];
    CalCVCell *cell = (CalCVCell *)[self.collectionView cellForItemAtIndexPath:path];
    [UIView animateWithDuration:0.5 animations:^{
        cell.month.alpha = 0;
    }];
    
    self.checkToday = YES;
    self.cal = self.todayObject;
    self.currentCheckingMonth = self.monthForToday;
    self.willDisplayPosition = self.monthForToday;
    path = [NSIndexPath indexPathForRow:self.monthForToday inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    
    [self performSelector:@selector(hideMonthCover) withObject:nil afterDelay:0.5];
}

- (IBAction)setting:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"menu_segue" sender:sender];
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)gesture
{
    [self performSegueWithIdentifier:@"menu_segue" sender:gesture];
}

- (void)hideMonthCover
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.currentCheckingMonth inSection:0];
    CalCVCell *cell = (CalCVCell *)[self.collectionView cellForItemAtIndexPath:path];
    [UIView animateWithDuration:0.5 animations:^{
        cell.monthCover.alpha = 0;
    } completion:^(BOOL finished) {
        cell.monthCover.hidden = YES;
    }];
}

- (void)tapHandler:(UITapGestureRecognizer *)gesture
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.currentCheckingMonth inSection:0];
    CalCVCell *cell = (CalCVCell *)[self.collectionView cellForItemAtIndexPath:path];
    CGPoint touchLocation = [gesture locationInView:cell.bottomView];
    
    for (UIView *view in cell.bottomView.subviews)
    {
        if ([view isKindOfClass:[DayView class]] && CGRectContainsPoint(view.frame, touchLocation))
        {
            if ([(DayView *)view isInThisMonth] && (self.currentCheckingMonth != self.lastSelectionMonth || (![view isEqual:self.lastSelect] && self.currentCheckingMonth == self.lastSelectionMonth))) {
                view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
                
                // Clear Today
                if (![view isEqual:self.todayView] && self.currentCheckingMonth == self.monthForToday) {
                    self.todayView.backgroundColor = [UIColor whiteColor];
                }
                
                // Clear last selection
                if (self.currentCheckingMonth == self.lastSelectionMonth && self.lastSelect != nil) {
                    self.lastSelect.backgroundColor = [UIColor whiteColor];
                }
                
                self.lastSelect = view;
                self.lastSelectionMonth = self.currentCheckingMonth;
            }
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"menu_segue"]) {
        MenuVC *controller = (MenuVC *)segue.destinationViewController;
        
        // If it's under IOS 8, then take the screenshot
        NSInteger version = [[UIDevice currentDevice].systemVersion integerValue];
        if (version == 8) {
            UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, self.view.opaque, 0.0);
            [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage * sc = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            controller.backgroundImage = sc;
        }
    }
}

@end
