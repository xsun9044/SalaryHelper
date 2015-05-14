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

@interface CalCVC ()
@property (nonatomic) CGFloat fullHeight;
@property (nonatomic) CGFloat fullWidth;
@property (nonatomic) CGFloat heightBottom;

@property (nonatomic) NSInteger daysOfCurrentMonth;
@property (nonatomic) NSInteger daysOfLastMonth;
@property (nonatomic) NSInteger startWeekDayOfCurrentMonth;
@property (nonatomic) NSInteger count;

@property (nonatomic) BOOL hasToday;

@property (nonatomic, strong) NSIndexPath *todayIndex;
@property (nonatomic, strong) NSIndexPath *lastSelect;

@property (nonatomic) NSString *dayText;

@property (nonatomic, strong) DayCVCell *dayCell;
@end

@implementation CalCVC
#define OUTTER 1
#define INNER 2

// 200 years
#define startDate @"1914-01-01 00:00:00"
#define endDate @"2113-12-31 23:59:59"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.tabBarController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.fullHeight = [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.fullWidth = [[UIScreen mainScreen] bounds].size.width;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger months = [NSDate monthsBetweenDate:[NSDate getDateFromStringInUTC:startDate] andDate:[NSDate getDateFromStringInUTC:[NSDate getCurrentDateTime]]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:(months) inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
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
        return 6;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == OUTTER) {
        return [NSDate monthsBetweenDate:[NSDate getDateFromStringInUTC:startDate] andDate:[NSDate getDateFromStringInUTC:endDate]];
    } else {
        return 7;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == OUTTER) {
        CalCVCell *cell = (CalCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"month_cell" forIndexPath:indexPath];
        self.fullHeight = [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.fullWidth = [[UIScreen mainScreen] bounds].size.width;
        
        [cell.widthTop setConstant:_fullWidth];
        [cell.heightTop setConstant:_fullHeight / 5];
        [cell.heightCal setConstant:4*_fullHeight / 5];
        cell.widthTag.constant = (_fullWidth-6)/7;
        
        self.heightBottom = cell.heightCal.constant;
        cell.CalView.delegate = self;
        cell.CalView.dataSource = self;
        cell.CalView.bounces = NO;
        [cell.CalView setBackgroundColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]];
        [cell.CalView reloadData];
        
        [cell.pig setImage:[[UIImage imageNamed:@"piggy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [cell.pig.imageView setTintColor:[UIColor whiteColor]];
        
        cell.month.text = [NSString stringWithFormat:@"%@  %ld", [NSDate nameForMonth:indexPath.row%12 + 1], [[NSDate getYearFromStringInUTC:startDate] integerValue] + indexPath.row / 12];
        
        self.startWeekDayOfCurrentMonth = [NSDate getNumberOfWeekdayFromStringInUTC:[NSString stringWithFormat:@"%ld-%@-%d",[[NSDate getYearFromStringInUTC:startDate] integerValue] + indexPath.row / 12,[NSDate nameForMonth:indexPath.row%12 + 1],1]];
        //NSLog(@"%ld",(long)self.startWeekDayOfCurrentMonth);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        [dateFormatter setTimeZone:timeZone];
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",[[NSDate getYearFromStringInUTC:startDate] integerValue] + indexPath.row / 12,indexPath.row%12 + 1,1]];
        self.daysOfLastMonth = [NSDate getNumberOfDaysInWeek:date];
        //NSLog(@"%@",date);
        
        NSInteger nextMonth = indexPath.row%12 + 2;
        if (nextMonth > 12) {
            nextMonth = 1;
        } else if (nextMonth < 2) {
            nextMonth = 1;
        }
        
        if (nextMonth == 1) {
            date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",[[NSDate getYearFromStringInUTC:startDate] integerValue] + indexPath.row / 12 + 1,(long)nextMonth,1]];
        } else {
            date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",[[NSDate getYearFromStringInUTC:startDate] integerValue] + indexPath.row / 12,(long)nextMonth,1]];
        }
        self.daysOfCurrentMonth = [NSDate getNumberOfDaysInWeek:date];
        //NSLog(@"%@",date);
        
        cell.left.tag = indexPath.row - 1;
        cell.right.tag = indexPath.row + 1;
        
        [cell.rightImage changeTintColorOfUIImage:[UIImage imageNamed:@"right_arrow"] withColor:[UIColor whiteColor]];
        [cell.rightImage setContentMode:UIViewContentModeCenter];
        
        [cell.leftImage changeTintColorOfUIImage:[UIImage imageNamed:@"right_arrow"] withColor:[UIColor whiteColor]];
        [cell.leftImage rotateImage180Degrees];
        [cell.leftImage setContentMode:UIViewContentModeCenter];
        
        return cell;
    } else {
        DayCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"day_cell" forIndexPath:indexPath];
        //cell.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
        [cell.coverHeight setConstant:(self.heightBottom-6)/6];
        [cell.dayWidth setConstant:(_fullWidth-6)/7];
        
        if (indexPath.section == 0) {
            self.count = 1;
            if (indexPath.row >=  self.startWeekDayOfCurrentMonth - 1) {
                cell.day.text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1) - (self.startWeekDayOfCurrentMonth-1)];
                self.dayText = cell.day.text;
                cell.backgroundColor = [UIColor whiteColor];
                cell.cover.hidden = YES;
                cell.alpha = 1;
                if (indexPath.row == 0 || indexPath.row == 6) {
                    [cell.day setTextColor:[UIColor redColor]];
                } else {
                    [cell.day setTextColor:[UIColor blackColor]];
                }
            } else {
                cell.day.text = [NSString stringWithFormat:@"%ld", self.daysOfLastMonth - (self.startWeekDayOfCurrentMonth - 2 - indexPath.row)];
                self.dayText = cell.day.text;
                cell.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
                cell.cover.hidden = NO;
                cell.alpha = 1;
                [cell.day setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
                cell.layer.borderWidth = 0;
                [cell.day setTextColor:[UIColor blackColor]];
            }
        } else {
            if (7 + 7*(indexPath.section-1) + indexPath.row < self.startWeekDayOfCurrentMonth - 1 + self.daysOfCurrentMonth) {
                cell.day.text = [NSString stringWithFormat:@"%ld", (7 - self.startWeekDayOfCurrentMonth + 1) + 7*(indexPath.section-1) + (indexPath.row + 1)];
                self.dayText = cell.day.text;
                cell.backgroundColor = [UIColor whiteColor];
                cell.cover.hidden = YES;
                cell.alpha = 1;
                if (indexPath.row == 0 || indexPath.row == 6) {
                    [cell.day setTextColor:[UIColor redColor]];
                } else {
                    [cell.day setTextColor:[UIColor blackColor]];
                }
            } else {
                cell.day.text = [NSString stringWithFormat:@"%ld", (long)self.count];
                self.dayText = cell.day.text;
                self.count++;
                cell.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
                cell.cover.hidden = NO;
                cell.alpha = 1;
                [cell.day setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
                cell.layer.borderWidth = 0;
                [cell.day setTextColor:[UIColor blackColor]];
            }
        }
        self.dayCell = cell;
        
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
        return CGSizeMake((_fullWidth-6)/7, (self.heightBottom-6)/6);
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
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.todayIndex];
        cell.backgroundColor = [UIColor whiteColor];
        
        // Clear last selection
        cell = [collectionView cellForItemAtIndexPath:self.lastSelect];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        self.lastSelect = indexPath;
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
