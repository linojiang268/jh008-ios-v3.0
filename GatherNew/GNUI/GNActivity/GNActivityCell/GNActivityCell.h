//
//  GNActivityCell.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTVCBase.h"

@interface GNActivityCell : GNTVCBase

@property (weak, nonatomic) IBOutlet UIImageView *imageMain;

@property (weak, nonatomic) IBOutlet UIImageView *image_ActivityState;
@property (weak, nonatomic) IBOutlet UILabel *lb_ActivityState;

@property (weak, nonatomic) IBOutlet UILabel *btnPerfect;
@property (weak, nonatomic) IBOutlet UILabel *btnMyTeam;
@property (weak, nonatomic) IBOutlet UILabel *lbActivityTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbActivityLocation;
@property (weak, nonatomic) IBOutlet UILabel *btnIsMoney;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnPerfectConstraint;





@end
