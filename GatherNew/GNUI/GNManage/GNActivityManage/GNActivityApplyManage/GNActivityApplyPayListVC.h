//
//  GNActivityApplyPayListVC.h
//  GatherNew
//
//  Created by Culmore on 15/10/4.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTableVCBase.h"

@interface GNActivityApplyPayListVC : GNTableVCBase

@property(nonatomic, assign)NSInteger activityId;
@property(nonatomic, assign)UIViewController* controller;


+(instancetype)initWithActivity:(NSInteger)activityId controller:(UIViewController*)controller;

@end
