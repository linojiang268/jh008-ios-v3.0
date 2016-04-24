//
//  GNActivitySignInSearchVC.h
//  GatherNew
//
//  Created by yuanjun on 15/10/20.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"
#import "GNVMResponse.h"
#import "GNActivitySignInManageVC.h"

@interface GNActivitySignInManageSearchVC : GNVCBase

@property(nonatomic, strong) GNVMResponse * getSearchSignInListResponse;

@property(nonatomic, assign)NSInteger activityId;
@property(nonatomic, assign)NSUInteger subStaus;
@property(nonatomic, strong)GNActivitySignInManageVC *manageVC;

+ (instancetype)initWithActivityId:(NSUInteger)activityId subStaus:(NSUInteger)subStaus manageVC:(GNActivitySignInManageVC *)manageVC;

@end
