//
//  GNActivityManageAddNewVC.h
//  GatherNew
//
//  Created by apple on 15/10/23.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"
#import "GNActivityApplySuccessListVC.h"

@interface GNActivityManageAddNewVC : GNVCBase

@property(nonatomic, assign)NSInteger activityId;

+ (instancetype)initWithActivityId:(NSUInteger)activityId requirements:(NSArray *)requirements sucVC:(GNActivityApplySuccessListVC *)sucVC;


@end
