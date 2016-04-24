//
//  GNActivityApplyVerifyListVC.h
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTableVCBase.h"

@interface GNActivityApplyVerifyListVC : GNTableVCBase

@property(nonatomic, assign)NSInteger activityId;

@property(nonatomic, assign)UIViewController* controller;


+(instancetype)initWithActivity:(NSInteger)activityId controller:(UIViewController*)controller;
@end
