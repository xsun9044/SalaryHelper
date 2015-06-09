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

@property (nonatomic, strong) NSIndexPath *todayIndex;
@property (nonatomic, strong) NSIndexPath *lastSelect;

@property (nonatomic) NSString *dayText;

@property (nonatomic, strong) DayCVCell *dayCell;

@property (nonatomic, strong) DBManager *dbManger; // Required for database operations
@property (nonatomic, strong) CalendarObject *cal;
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
    
    self.fullHeight = [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.fullWidth = [[UIScreen mainScreen] bounds].size.width;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    
    self.currentCheckingMonth = INIT_CHECKING_MONTH;
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
        
        [cell.pig setImage:[[UIImage imageNamed:@"piggy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [cell.pig.imageView setTintColor:[UIColor whiteColor]];
        
        if (self.cal.currentMonthIndex == indexPath.row) {
            cell.month.text = [NSString stringWithFormat:@"%@  %ld", self.cal.monthName, self.cal.year];
        } else if (self.cal.currentMonthIndex > indexPath.row) {
            self.cal = self.cal.priorMonth;
            cell.month.text = [NSString stringWithFormat:@"%@  %ld", self.cal.monthName, self.cal.year];
        } else {
            self.cal = self.cal.nextMonth;
            cell.month.text = [NSString stringWithFormat:@"%@  %ld", self.cal.monthName, self.cal.year];
        }
        
        cell.left.tag = indexPath.row - 1;
        cell.right.tag = indexPath.row + 1;
        
        [cell.rightImage changeTintColorOfUIImage:[UIImage imageNamed:@"right_arrow"] withColor:[UIColor whiteColor]];
        [cell.rightImage setContentMode:UIViewContentModeCenter];
        
        [cell.leftImage changeTintColorOfUIImage:[UIImage imageNamed:@"right_arrow"] withColor:[UIColor whiteColor]];
        [cell.leftImage rotateImage180Degrees];
        [cell.leftImage setContentMode:UIViewContentModeCenter];
        
        if (self.monthForToday == indexPath.row) {
            cell.todayBtn.hidden = YES;
        } else {
            cell.todayBtn.hidden = NO;
        }
        
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
            cell.tag = 1;
            
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        }
        
        
        self.dayCell = cell;
        
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == OUTTER) {
        if (indexPath.row%12 + 1 == [[NSDate getMonthFromStringInUTC:[NSDate getCurrentDateTime]] integerValue]
            &&
            [[NSDate getYearFromStringInUTC:startDate] integerValue] + indexPath.row / 12 == [[NSDate getYearFromStringInUTC:[NSDate getCurrentDateTime]] integerValue]) {
            self.hasToday = YES;
        } else {
            self.hasToday = NO;
        }
    } else {
        if (cell.tag != 0) {
            if (self.hasToday && [self.dayText integerValue] == [[NSDate getDayFromStringInUTC:[NSDate getCurrentDateTime]] integerValue]) {
                [self.dayCell.day setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
                self.dayCell.layer.borderWidth = 1.0f;
                self.todayIndex = indexPath;
                self.dayCell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
            } else {
                [self.dayCell.day setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
                self.dayCell.layer.borderWidth = 0;
                self.dayCell.backgroundColor = [UIColor whiteColor];
            }
        }
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

#pragma mark - Actions
- (IBAction)goLeft:(UIButton *)sender
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
}

- (IBAction)goRight:(UIButton *)sender
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
}

- (IBAction)checkToday:(UIButton *)sender
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.monthForToday inSection:0];
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
