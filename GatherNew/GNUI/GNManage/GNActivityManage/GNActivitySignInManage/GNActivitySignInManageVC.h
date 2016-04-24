//
//  GNActivitySignInManageVC.h
//  GatherNew
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"

@interface GNActivitySignInManageVC : GNVCBase

@property(nonatomic, assign)NSInteger activityId;
@property(nonatomic, assign)NSUInteger subStatus;

+ (instancetype)initWithActivityId:(NSUInteger)activityId subStatus:(NSUInteger)subStatus;

-(void)refreshDataAfterSearch;

@end
