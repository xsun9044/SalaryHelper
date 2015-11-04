//
//  DayDetailPopVC.h
//  SalaryHelper
//
//  Created by Xin Sun on 10/3/15.
//  Copyright © 2015 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayView.h"
#import "DayObject.h"

@protocol DayDetailViewDelegate <NSObject>
- (void)openOtherView:(CGPoint)point;
- (void)pickOtherDay:(CGPoint)point;
@end

@interface DayDetailPopVC : UIViewController
@property (nonatomic, weak) id<DayDetailViewDelegate> delegate;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) DayView *dayView;
@property (nonatomic, strong) NSArray *events;
@end
