//
//  GNEditOldPasswordVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginBaseVC.h"

@interface GNEditOldPasswordVC : GNLoginBaseVC

@property (weak, nonatomic) IBOutlet UILabel *lbOldPWD;
@property (weak, nonatomic) IBOutlet UILabel *lbFirstPWD;
@property (weak, nonatomic) IBOutlet UILabel *lbSecondPWD;

@property (weak, nonatomic) IBOutlet UITextField *txtOldPWD;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstPWD;
@property (weak, nonatomic) IBOutlet UITextField *txtSecondPWD;


@property (weak, nonatomic) IBOutlet UIView *view_Line1;
@property (weak, nonatomic) IBOutlet UIView *view_Line2;
@property (weak, nonatomic) IBOutlet UIView *view_Line3;
@property (weak, nonatomic) IBOutlet UIView *view_Line4;

@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@end
