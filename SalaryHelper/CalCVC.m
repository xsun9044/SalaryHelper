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
#import "AppDelegate.h"
#import "SystemHelper.h"
#import "CalendarObject.h"
#import "DayObject.h"

@interface CalCVC ()
@property (nonatomic) CGFloat fullHeight;
@property (nonatomic) CGFloat fullWidth;
@property (nonatomic) CGFloat heightBottom;

@property (nonatomic) NSInteger daysOfCurrentMonth;
@property (nonatomic) NSInteger daysOfLastMonth;
@property (nonatomic) NSInteger startWeekDayOfCurrentMonth;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger currentCheckingMonth;
@property (nonatomic) NSInteger willDisplayPosition;
@property (nonatomic) NSInteger monthForToday;
@property (nonatomic) NSInteger lastSelectionMonth;

@property (nonatomic) BOOL hasToday;
@property (nonatomic) BOOL checkToday;

@property (nonatomic, strong) NSIndexPath *todayIndex;
@property (nonatomic, strong) NSIndexPath *lastSelect;

@property (nonatomic) NSString *dayText;

@property (nonatomic, strong) DayCVCell *dayCell;

@property (nonatomic, strong) DBManager *dbManger; // Required for database operations

@property (nonatomic, strong) CalendarObject *cal;
@property (nonatomic, strong) CalendarObject *todayObject;

@property (nonatomic, strong) UIView *menuBtnView;
@end

@implementation CalCVC
#define OUTTER 1
#define INNER 2
#define INIT_CHECKING_MONTH -1

- (DBManager *)dbManger
{
    if (!_dbManger) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _dbManger = delegate.dbManger;
    }
    
    return _dbManger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.tabBarController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.fullHeight = [[UIScreen mainScreen] bounds].size.height;
    self.fullWidth = [[UIScreen mainScreen] bounds].size.width;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    
    self.currentCheckingMonth = INIT_CHECKING_MONTH;
    
    self.menuBtnView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-6)/7 * 6, 0, [UIScreen mainScreen].bounds.size.width, 38)];
    [self.menuBtnView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-6)/7/2 - 12, 8, 24, 24)];
    
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
    if (collectionView.tag == OUTTER) {
        return 1;
    } else {
        return self.cal.daysArray.count / 7;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == OUTTER) {
        return [NSDate monthsBetweenDate:[NSDate getDateTimeFromStringInUTC:startDate] andDate:[NSDate getDateTimeFromStringInUTC:endDate]];
    } else {
        return 7;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == OUTTER) { // Month collection cell
        self.willDisplayPosition = indexPath.row;
        
        CalCVCell *cell = (CalCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"month_cell" forIndexPath:indexPath];
        
        self.fullHeight = [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.fullWidth = [[UIScreen mainScreen] bounds].size.width;
        [cell.widthTop setConstant:_fullWidth];
        [cell.heightTop setConstant:_fullHeight / 5];
        [cell.heightCal setConstant:4*_fullHeight / 5];
        cell.widthTag.constant = (_fullWidth-6)/7;
        self.heightBottom = cell.heightCal.constant;
        
        cell.CalView.bounces = NO;
        [cell.CalView setBackgroundColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]];
        
        if (self.checkToday) {
            [UIView animateWithDuration:0.3f animations:^{
                cell.month.alpha = 1;
            }];
        }
        self.checkToday = NO;
        
        if (self.cal.currentMonthIndex == indexPath.row) {
            cell.month.text = [NSString stringWithFormat:@"%@  %ld", self.cal.monthName, self.cal.year];
        } else if (self.cal.currentMonthIndex > indexPath.row) {
            CalendarObject *object = self.cal;
            self.cal = self.cal.priorMonth;
            cell.month.text = [NSString stringWithFormat:@"%@  %ld", self.cal.monthName, self.cal.year];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Do background work
                self.cal = [[CalendarObject alloc] initDataWhenMoveLeft:object.priorMonth and:object];
            });
        } else {
            CalendarObject *object = self.cal;
            self.cal = self.cal.nextMonth;
            cell.month.text = [NSString stringWithFormat:@"%@  %ld", self.cal.monthName, self.cal.year];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Do background work
                self.cal = [[CalendarObject alloc] initDataWhenMoveRight:object.nextMonth and:object];
            });
        }
        
        if (self.monthForToday == indexPath.row) {
            cell.todayBtn.hidden = YES;
        } else {
            cell.todayBtn.hidden = NO;
        }
        
        if (self.cal)
        
        cell.CalView.delegate = self;
        cell.CalView.dataSource = self;
        [cell.CalView reloadData];
        
        return cell;
    } else { // Collection cell for everyday in a single month
        DayCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"day_cell" forIndexPath:indexPath];
        [cell.coverHeight setConstant:(self.heightBottom-	self.cal.daysArray.count/7)/(self.cal.daysArray.count/7)];
        [cell.dayWidth setConstant:(_fullWidth-6)/7];
        
        DayObject *day = [self.cal.daysArray objectAtIndex:indexPath.section * 7 + indexPath.row];
        cell.day.text = day.day;
        self.dayText = cell.day.text;
        cell.cover.hidden = day.inThisMonth;
        cell.alpha = 1;
        [cell.day setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
        [cell.day setTextColor:[UIColor blackColor]];
        cell.layer.borderWidth = 0;
        if (day.inThisMonth) {
            if (indexPath.row == 0 || indexPath.row == 6) {
                [cell.day setTextColor:[UIColor redColor]];
            } else {
                [cell.day setTextColor:[UIColor blackColor]];
            }
            
            cell.backgroundColor = [UIColor whiteColor];
            
            cell.tag = 1;
        } else {
            cell.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
            cell.tag = 0;
        }
        
        if (day.isToday) {
            [cell.day setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
            cell.layer.borderWidth = 1.0f;
            self.todayIndex = indexPath;
            cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        } else {
            [cell.day setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
            cell.layer.borderWidth = 0;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        /*NSString *dateString = [NSDate getDateStringWithYear:[[NSDate getYearFromStringInUTC:startDate] integerValue] + self.willDisplayPosition / 12
         andMonth:self.willDisplayPosition%12 + 1
         andDay:[cell.day.text integerValue]];
         NSLog(@"%@", dateString);
         
         [self.dbManger getEventsForDate:dateString
         withCompletionHandler:^(BOOL finished, NSArray *result, NSError *error) {
         if (finished) {
         if (result.count > 0) {
         NSLog(@"%@", result);
         }
         }
         }];*/
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == OUTTER) {
        return CGSizeMake(_fullWidth, _fullHeight);
    } else {
        return CGSizeMake((_fullWidth-6)/7, (self.heightBottom-self.cal.daysArray.count/7)/(self.cal.daysArray.count/7));
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == OUTTER && self.willDisplayPosition != indexPath.row) {
        self.currentCheckingMonth = self.willDisplayPosition;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == OUTTER) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(1, 0, 0, 0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag != OUTTER) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (cell.tag != 0 && !([indexPath isEqual:self.lastSelect] && self.currentCheckingMonth == self.lastSelectionMonth)) {
            cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
            
            // Clear Today
            if (![indexPath isEqual:self.todayIndex] && self.currentCheckingMonth == self.monthForToday) {
                cell = [collectionView cellForItemAtIndexPath:self.todayIndex];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            // Clear last selection
            if (self.currentCheckingMonth == self.lastSelectionMonth) {
                cell = [collectionView cellForItemAtIndexPath:self.lastSelect];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.lastSelect = indexPath;
            self.lastSelectionMonth = self.currentCheckingMonth;
        }
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.menuBtnView.alpha = 0;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.menuBtnView.alpha = 1;
    }];
}

#pragma mark - Actions
- (IBAction)checkToday:(UIButton *)sender
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.currentCheckingMonth inSection:0];
    CalCVCell *cell = (CalCVCell *)[self.collectionView cellForItemAtIndexPath:path];
    [UIView animateWithDuration:0.3 animations:^{
        cell.month.alpha = 0;
    }];
    
    self.checkToday = YES;
    self.cal = self.todayObject;
    self.currentCheckingMonth = self.monthForToday;
    path = [NSIndexPath indexPathForRow:self.monthForToday inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
}

- (IBAction)setting:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"menu_segue" sender:sender];
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
