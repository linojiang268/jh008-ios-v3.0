//
//  GNUpdatePasswordVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginBaseVC.h"

@interface GNUpdatePasswordVC : GNLoginBaseVC
@property (weak, nonatomic) IBOutlet UILabel *lbPhoneTitlePro;
@property (weak, nonatomic) IBOutlet UILabel *lbRegisterCodeTitlePro;
@property (weak, nonatomic) IBOutlet UILabel *lbpwdTitlePro;

@property (weak, nonatomic) IBOutlet UITextField *txtPhonePro;
@property (weak, nonatomic) IBOutlet UITextField *txtRegisterCodePro;
@property (weak, nonatomic) IBOutlet UITextField *txtPWDPro;

@property (weak, nonatomic) IBOutlet UIButton *btnGetCodePro;
@property (weak, nonatomic) IBOutlet UIButton *btnNextPro;

@property (weak, nonatomic) IBOutlet UIView *view_Line1;
@property (weak, nonatomic) IBOutlet UIView *view_Line2;
@property (weak, nonatomic) IBOutlet UIView *view_Line3;
@property (weak, nonatomic) IBOutlet UIView *view_Line4;



@end
