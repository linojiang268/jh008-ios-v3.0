//
//  GNActivityScoreStarLevelVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseVC.h"
#import "GNActivityScoreModel.h"

@interface GNActivityScoreStarLevelVC : GNActivityBaseVC
@property (weak, nonatomic) IBOutlet UIView *viewLine1;
@property (weak, nonatomic) IBOutlet UIView *viewLine2;
@property (weak, nonatomic) IBOutlet UIView *viewLine3;
@property (weak, nonatomic) IBOutlet UIView *viewLine4;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbActivityInfo;
@property (weak, nonatomic) IBOutlet UIButton *brnSponsor;
@property (weak, nonatomic) IBOutlet UIButton *btnActivityDetails;
@property (weak, nonatomic) IBOutlet UIButton *btnPictures;

@property (weak, nonatomic) IBOutlet UIButton *btnScore1;
@property (weak, nonatomic) IBOutlet UIButton *btnScore2;
@property (weak, nonatomic) IBOutlet UIButton *btnScore3;
@property (weak, nonatomic) IBOutlet UIButton *btnScore4;
@property (weak, nonatomic) IBOutlet UIButton *btnScore5;

@property (nonatomic, strong) GNActivity *activity;

- (IBAction)btnScoreAction:(id)sender;
@end
