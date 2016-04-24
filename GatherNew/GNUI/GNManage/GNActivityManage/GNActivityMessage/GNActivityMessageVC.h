//
//  GNActivityMessageVC.h
//  GatherNew
//
//  Created by yuanjun on 15/10/12.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"

@interface GNActivityMessageVC : GNVCBase

@property(nonatomic, assign)NSInteger activityId;


+ (instancetype)initWithActivity:(NSUInteger)activityId;

@end
