//
//  GNActivityApplySuccessListVC.h
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNTableVCBase.h"


@interface GNActivityApplySuccessListVC : GNTableVCBase

@property(nonatomic, assign) NSInteger activityId;

+(instancetype)initWithActivity:(NSInteger) activityId;

-(void)refreshTableAfterAddNew;

@end
