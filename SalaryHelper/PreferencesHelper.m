//
//  PreferencesHelper.m
//  Phenom
//
//  Created by Xin on 5/29/15.
//  Copyright (c) 2015 James Chung. All rights reserved
//
//  Including all the functions used for local user

#import "PreferencesHelper.h"

@implementation PreferencesHelper

#define SUBMIT_SUCCESS @"submit_success"

- (void)returnFromSubmitSuccess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:SUBMIT_SUCCESS];
    [defaults synchronize];
}

- (void)resetReturnFromSubmitSuccess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:SUBMIT_SUCCESS];
    [defaults synchronize];
}

- (BOOL)getSumbitSuccessFlag
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:SUBMIT_SUCCESS];
}

@end
