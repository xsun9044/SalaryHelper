//
//  MyPopupVC.h
//  SalaryHelper
//
//  Created by Xin on 5/5/15.
//  Copyright (c) 2015 Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopupDelegate <NSObject>
- (void)OKClicked;

- (void)CancelClicked;
@end

@interface MyPopupVC : UIViewController

@property (nonatomic, weak) id <PopupDelegate>delegate;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *contentString;

@end

