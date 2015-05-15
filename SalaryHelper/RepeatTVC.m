//
//  RepeatTVC.m
//  SalaryHelper
//
//  Created by Xin Sun on 15/5/15.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "RepeatTVC.h"
#import "InputTVCell.h"

@interface RepeatTVC() <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic) BOOL moreThanOne;
@property (nonatomic) BOOL changed;
@property (nonatomic) BOOL showPicker;

@property (nonatomic,strong) NSArray *lastData;

@property (weak, nonatomic) IBOutlet UILabel *customTitle;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@end

@implementation RepeatTVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Hide back bar button title for next view
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @""
                                   style: UIBarButtonItemStyleBordered
                                   target:self action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    // This will remove extra separators from tableview for iOS 8,7 and 6
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W3" size:13.0]}
                                           forState:UIControlStateNormal];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITableView Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blank" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 8) {
        InputTVCell *cell = (InputTVCell *)[tableView dequeueReusableCellWithIdentifier:@"picker" forIndexPath:indexPath];
        cell.picker2.delegate = self;
        cell.picker2.dataSource = self;
        
        if (self.showPicker) {
            cell.picker2.hidden = NO;
            cell.picker2.alpha = 0;
            [UIView animateWithDuration:0.9 animations:^{
                cell.picker2.alpha = 1;
            }];
            if (self.lastData.count == 2) {
                [cell.picker2 selectRow:[[self.lastData objectAtIndex:0] integerValue]-1
                            inComponent:0
                               animated:YES];
                
                if ([[self.lastData objectAtIndex:0] integerValue] > 1) {
                    [cell.picker2 selectRow:[[self.lastData objectAtIndex:1] isEqualToString:@"Days"]?0:[[self.lastData objectAtIndex:1] isEqualToString:@"Weeks"]?1:[[self.lastData objectAtIndex:1] isEqualToString:@"Months"]?2:3
                                inComponent:1
                                   animated:YES];
                    self.moreThanOne = YES;
                    self.changed = YES;
                } else {
                    [cell.picker2 selectRow:[[self.lastData objectAtIndex:1] isEqualToString:@"Day"]?0:[[self.lastData objectAtIndex:1] isEqualToString:@"Week"]?1:[[self.lastData objectAtIndex:1] isEqualToString:@"Month"]?2:3
                                inComponent:1
                                   animated:YES];
                    self.moreThanOne = NO;
                    self.changed = NO;
                }
            }
            [cell.picker2 reloadAllComponents];
        } else {
            cell.picker2.hidden = YES;
        }
        
        return cell;
    }
    
    InputTVCell *cell = (InputTVCell *)[tableView dequeueReusableCellWithIdentifier:@"repeat_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.label1.text = @"Never";
    } else if (indexPath.row == 1) {
        cell.label1.text = @"Every Day";
    } else if (indexPath.row == 2) {
        cell.label1.text = @"Every Week";
    } else if (indexPath.row == 3) {
        cell.label1.text = @"Every 2 Weeks";
    } else if (indexPath.row == 4) {
        cell.label1.text = @"Every Month";
    } else if (indexPath.row == 5) {
        cell.label1.text = @"Every Year";
    } else if (indexPath.row == 7) {
        cell.label1.text = @"Custom";
    }
    
    if (self.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 8) {
        if (self.showPicker) {
            return 162;
        } else {
            return 0;
        }
    }
    return 44;
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
    if (indexPath.row != 6 && indexPath.row != 7 && indexPath.row != 8 && indexPath.row != self.row) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        InputTVCell *cell = (InputTVCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.row inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell = (InputTVCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.row = indexPath.row;
        
        self.showPicker = NO;
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        
        self.repeatString = cell.label1.text;
    } else if (indexPath.row == 7) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if (self.row != indexPath.row) {
            InputTVCell *cell = (InputTVCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.row inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            //self.row = indexPath.row;
        }
        InputTVCell *cell = (InputTVCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (self.showPicker) {
            self.showPicker = NO;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        } else {
            self.showPicker= YES;
            if (self.row != 7) {
                self.repeatString = @"Every Day";
            } else {
                NSLog(@"%@",[self getRepeat:self.repeatString]);
                self.lastData = [self getRepeat:self.repeatString];
            }
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        
        self.row = indexPath.row;
    } else if (indexPath.row != 8) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        self.showPicker = NO;
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (NSArray *)getRepeat:(NSString *)string
{
    NSArray *items = [string componentsSeparatedByString:@" "];
    if (items.count == 2) {
        // etc. Every Day
        return [[NSArray alloc] initWithObjects:@"1", [items objectAtIndex:1],nil];
    } else {
        // etc Every 5 Days
        return [[NSArray alloc] initWithObjects:[items objectAtIndex:1], [items objectAtIndex:2],nil];
    }
}

#pragma mark - UIPickerView Delegate
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.hidden) {
        return 0;
    }
    return 2;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 40000;
    }
    return 4;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d",row + 1];
    } else {
        if (self.moreThanOne) {
            return row == 0?@"Days":row == 1?@"Weeks":row == 2?@"Months":@"Years";
        } else {
            return row == 0?@"Day":row == 1?@"Week":row == 2?@"Month":@"Year";
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d,%d", row, component);
    if (component == 0 && row>0) {
        self.moreThanOne = YES;
        if (!self.changed) {
            [pickerView reloadComponent:1];
            self.changed = YES;
        }
    } else if (component == 0 && row==0) {
        self.moreThanOne = NO;
        if (self.changed) {
            [pickerView reloadComponent:1];
            self.changed = NO;
        }
    }
    
    if (self.moreThanOne) {
        self.repeatString = [NSString stringWithFormat:@"Every %d %@",[pickerView selectedRowInComponent:0] + 1, [pickerView selectedRowInComponent:1]==0?@"Days":[pickerView selectedRowInComponent:1]==1?@"Weeks":[pickerView selectedRowInComponent:1] == 2?@"Months":@"Years"];
    } else {
        self.repeatString = [NSString stringWithFormat:@"Every %@", [pickerView selectedRowInComponent:1]==0?@"Day":[pickerView selectedRowInComponent:1]==1?@"Week":[pickerView selectedRowInComponent:1]==2?@"Month":@"Year"];
    }
    
    self.customTitle.text = [NSString stringWithFormat:@"Event will repeat %@", [self.repeatString lowercaseString]];
}

#pragma mark - Actions
- (IBAction)done:(id)sender
{
    if (self.repeatString.length == 0) {
        self.repeatString = @"Never";
    }
    //NSLog(@"%d - %@", self.row ,self.repeatString);
    
    [self.delegate getRepeatType:self.repeatString withNumber:self.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
