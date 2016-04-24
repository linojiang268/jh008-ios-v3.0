//
//  GNMeActivityCell.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTVCBase.h"
#import "GNUIMarkLabel.h"

@interface GNMeActivityCell : GNTVCBase
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbActivityName;
@property (weak, nonatomic) IBOutlet UILabel *lbPosition;
@property (weak, nonatomic) IBOutlet UILabel *lbJoinPersonNumber;

@property (weak, nonatomic) IBOutlet GNUIMarkLabel *markLabel;

@property (assign, nonatomic) NSInteger activityId;

@end
