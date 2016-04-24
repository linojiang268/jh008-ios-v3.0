//
//  GNRegisterVC.h
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginBaseVC.h"
#import "GNPerfectInfoNPS.h"

@interface GNRegisterVC : GNLoginBaseVC

@property (weak, nonatomic) IBOutlet UITextField *txt_RegisterCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_GetCodePro;
@property (weak, nonatomic) IBOutlet UILabel *lb_SendAlertPro;
@property (weak, nonatomic) IBOutlet UIButton *btn_OkPro;

@property(strong,nonatomic) GNPerfectInfoNPS *perfectInfoNPS;
@property(strong,nonatomic) NSArray *tagIds;

@end
