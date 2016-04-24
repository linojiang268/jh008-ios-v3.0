//
//  GNLoginStartVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginStartVC.h"

@implementation GNLoginStartVC

+(NSString *)sbIdentifier{
    return @"loginstart";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

@end
