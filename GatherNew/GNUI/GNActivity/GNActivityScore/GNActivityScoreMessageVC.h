//
//  GNActivityScoreMessageVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseVC.h"

@interface GNActivityScoreMessageVC : GNActivityBaseVC

@property (weak, nonatomic) IBOutlet UIButton *btnTraffic;
@property (weak, nonatomic) IBOutlet UIButton *btnSignin;
@property (weak, nonatomic) IBOutlet UIButton *btnActivityOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnActivityExperience;
@property (weak, nonatomic) IBOutlet UIButton *btnHaveDinner;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;

@property (weak, nonatomic) IBOutlet UITextView *txtFieldView;

@property (weak, nonatomic) IBOutlet UIButton *btnScore1;
@property (weak, nonatomic) IBOutlet UIButton *btnScore2;
@property (weak, nonatomic) IBOutlet UIButton *btnScore3;
@property (weak, nonatomic) IBOutlet UIButton *btnScore4;
@property (weak, nonatomic) IBOutlet UIButton *btnScore5;

@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@end
