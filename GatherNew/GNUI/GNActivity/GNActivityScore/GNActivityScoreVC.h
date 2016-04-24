//
//  GNActivityScoreVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseVC.h"
#import "GNActivityScoreModel.h"

@interface GNActivityScoreVC : GNActivityBaseVC

@property (strong, nonatomic) NSMutableArray *mutArrayData;

@property (strong, nonatomic) GNActivity *activity;

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *btnScore1;
@property (weak, nonatomic) IBOutlet UIButton *btnScore2;
@property (weak, nonatomic) IBOutlet UIButton *btnScore3;
@property (weak, nonatomic) IBOutlet UIButton *btnScore4;
@property (weak, nonatomic) IBOutlet UIButton *btnScore5;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;

- (IBAction)btnScoreAction:(id)sender;

@end
