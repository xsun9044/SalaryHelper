//
//  AddTVC.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/13.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "AddTVC.h"
#import "InputTVCell.h"
#import "UIImageView+imageViewHelper.h"
#import "NSDate+DateHelper.h"
#import "UIView+ViewHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "RepeatTVC.h"
#import "MyPopupVC.h"
#import "PreferencesHelper.h"
#import "AppDelegate.h"

#define HIDE_HUD_INTEVAL 5

@interface AddTVC() <UITextFieldDelegate, RepeatDelegate>
@property (nonatomic, strong) PreferencesHelper * preferences;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;

@property (strong, nonatomic) UITextField *currentTextField1;
@property (strong, nonatomic) UITextField *currentTextField2;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *repeatLabel;

@property (strong, nonatomic) UIButton *clearButton1;
@property (strong, nonatomic) UIButton *clearButton2;

@property (nonatomic) BOOL showCal;

@property (nonatomic) NSInteger repeatRow;

@property (nonatomic, strong) NSString *headerString;
@property (nonatomic, strong) NSString *contentString;
@end

@implementation AddTVC

- (PreferencesHelper *)preferences
{
    if (!_preferences) _preferences = [[PreferencesHelper alloc] init];
    return _preferences;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.tabBarController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // Hide back bar button title for next view
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @""
                                   style: UIBarButtonItemStyleBordered
                                   target:self action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    // This will remove extra separators from tableview for iOS 8,7 and 6
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W3" size:13.0]}
                                           forState:UIControlStateNormal];
    [self.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W3" size:13.0]}
                                           forState:UIControlStateNormal];
    
    self.repeatRow = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification
{
    [self.tableView scrollsToTop];
}

#pragma mark - UITableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InputTVCell *cell;
    if (indexPath.row == 0) {
        cell = (InputTVCell *)[tableView dequeueReusableCellWithIdentifier:@"lv1" forIndexPath:indexPath];
        self.currentTextField1 = cell.input1;
        self.currentTextField2 = cell.input2;
        cell.input1.delegate = self;
        cell.input2.delegate = self;
        
        self.clearButton1 = cell.btn1;
        self.clearButton2 = cell.btn2;
    } else if (indexPath.row == 1) {
        cell = (InputTVCell *)[tableView dequeueReusableCellWithIdentifier:@"blank" forIndexPath:indexPath];
    } else if (indexPath.row == 2) {
        cell = (InputTVCell *)[tableView dequeueReusableCellWithIdentifier:@"lv2" forIndexPath:indexPath];
        [cell.icon1 changeTintColorOfUIImage:[UIImage imageNamed:@"calendar"] withColor:[UIColor blackColor]];
        self.dateLabel = cell.label1;
        if ([self.dateLabel.text isEqualToString:@"--"]) {
            self.dateLabel.text = [NSDate getCurrentDate];
        }
    } else if (indexPath.row == 3) {
        cell = (InputTVCell *)[tableView dequeueReusableCellWithIdentifier:@"picker" forIndexPath:indexPath];
        if (self.showCal) {
            cell.picker.hidden = NO;
            cell.picker.alpha = 0;
            [UIView animateWithDuration:0.9 animations:^{
                cell.picker.alpha = 1;
            }];
        } else {
            cell.picker.hidden = YES;
        }
        
        [cell.picker addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
    } else {
        cell = (InputTVCell *)[tableView dequeueReusableCellWithIdentifier:@"lv3" forIndexPath:indexPath];
        self.repeatLabel = cell.label1;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 61;
    } else if (indexPath.row == 1) {
        return 40;
    } else if (indexPath.row == 2) {
        return 43;
    } else if (indexPath.row == 3) {
        if (self.showCal) {
            return 162;
        } else {
            return 0;
        }
    } else {
        return 43;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        InputTVCell *cell = (InputTVCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (self.showCal) {
            cell.icon2.image = [UIImage imageNamed:@"arrowdown"];
            self.showCal = NO;
            
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        } else {
            cell.icon2.image = [UIImage imageNamed:@"arrowup"];
            self.showCal = YES;
            
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    } else if (self.showCal) {
        InputTVCell *cell = (InputTVCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.icon2.image = [UIImage imageNamed:@"arrowdown"];
        self.showCal = NO;
        
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.currentTextField1]) {
        self.clearButton1.hidden = NO;
        self.clearButton2.hidden = YES;
    } else {
        [self.currentTextField2 setPlaceholder:@"Amount"];
        self.clearButton1.hidden = YES;
        self.clearButton2.hidden = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.currentTextField1]) {
        self.clearButton1.hidden = YES;
    } else {
        self.clearButton2.hidden = YES;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.currentTextField1 resignFirstResponder];
    [self.currentTextField2 resignFirstResponder];
}

#pragma mark - Actions
- (IBAction)cacel:(UIBarButtonItem *)sender
{
    [self.currentTextField1 resignFirstResponder];
    [self.currentTextField2 resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearInput:(UIButton *)sender
{
    if (sender.tag == 0) {
        self.currentTextField1.text = @"";
    } else {
        self.currentTextField2.text = @"";
    }
}

- (void)getDate:(UIDatePicker *)picker
{
    self.dateLabel.text = [NSDate getDateStringFromDate:picker.date];
}

// Done Action
- (IBAction)done:(UIBarButtonItem *)sender
{
    if (self.currentTextField2.text.length == 0) {
        [self.currentTextField2 showAlertBorderWithCornerRadius:5.0f];
        [self.currentTextField2 setPlaceholder:@"Required"];
        [self buildAlertPopupWithTitle:@"Amount Value Required" andContext:@"Please input your income amount."];
        [self performSegueWithIdentifier:@"show_popup" sender:sender];
    } else if (![self checkInputIfNumberic:self.currentTextField2.text]) {
        [self.currentTextField2 showAlertBorderWithCornerRadius:5.0f];
        [self buildAlertPopupWithTitle:@"Amount Format Error" andContext:@"Please input number for your income amount."];
        [self performSegueWithIdentifier:@"show_popup" sender:sender];
    } else {
        [self.currentTextField1 resignFirstResponder];
        [self.currentTextField2 resignFirstResponder];
        [self.currentTextField2 hideAlertBorder];
        
        //Prepare data
        BOOL willRepeat = NO;
        NSArray *repeatData;
        if (![self.repeatLabel.text isEqualToString:@"Never"]) {
            BOOL willRepeat = YES;
            
            // Handle repeat data
            NSString *qty;
            NSString *measure;
            NSArray *parts = [self.repeatLabel.text componentsSeparatedByString:@" "];
            if (parts.count == 2) {
                qty = @"1";
                measure = parts[1];
            } else {
                qty = parts[1];
                measure = parts[2];
            }
            
            repeatData = [[NSArray alloc] initWithObjects:
                                   [measure isEqualToString:@"Day"]||[measure isEqualToString:@"Days"]?qty:@"0", //0
                                   [measure isEqualToString:@"Week"]||[measure isEqualToString:@"Weeks"]?qty:@"0", //1
                                   [measure isEqualToString:@"Month"]||[measure isEqualToString:@"Months"]?qty:@"0", //2
                                   [measure isEqualToString:@"Year"]||[measure isEqualToString:@"Years"]?qty:@"0", //3
                                   nil];
        } else {
            repeatData = [[NSArray alloc] initWithObjects:@"0",@"0",@"0",@"0",nil];
        }
        
        NSLog(@"%@", repeatData);
        
        HUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        HUD.labelText = @"Saving...";
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.dbManger saveIncomeEvent:self.currentTextField1.text
                                    amount:self.currentTextField2.text
                                 startDate:self.dateLabel.text
                                    repeat:willRepeat
                                       day:[[repeatData objectAtIndex:0] integerValue]
                                      week:[[repeatData objectAtIndex:1] integerValue]
                                     month:[[repeatData objectAtIndex:2] integerValue]
                                      year:[[repeatData objectAtIndex:3] integerValue]
                      andCompletionHandler:^(BOOL finished, NSError *error) {
                          [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                          if (finished) { // success
                              [self.preferences returnFromSubmitSuccess]; // Set flag for submit success
                              [self dismissViewControllerAnimated:YES completion:nil];
                          } else { // failure
#warning TODO: ERROR HANDLE
                              NSLog(@"%@", error.localizedDescription);
                          }
                      }];
        [HUD hide:YES afterDelay:HIDE_HUD_INTEVAL];
    }
}

- (void)buildAlertPopupWithTitle:(NSString *)title andContext:(NSString *)content
{
    self.headerString = title;
    self.contentString = content;
}

- (BOOL)checkInputIfNumberic:(NSString *)text
{
    NSString *expression = @"^([0-9]+)(\\.([0-9]+)?)?$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, [text length])];
    if (numberOfMatches == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - Repeat Delegate
- (void)getRepeatType:(NSString *)typeName withNumber:(NSInteger)num
{
    self.repeatLabel.text = typeName;
    self.repeatRow = num;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"repeat_segue"]) {
        RepeatTVC *controller = (RepeatTVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.row = self.repeatRow;
        controller.repeatString = self.repeatLabel.text;
    } else if ([segue.identifier isEqualToString:@"show_popup"]) {
        MyPopupVC *controller = (MyPopupVC *)segue.destinationViewController;
        controller.contentString = self.contentString;
        controller.header = self.headerString;
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
