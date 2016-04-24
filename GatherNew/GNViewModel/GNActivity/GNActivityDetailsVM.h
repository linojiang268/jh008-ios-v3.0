//
//  GNActivityDetailsVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNActivityDetailsModel.h"

@interface GNActivityDetailsVM : GNVMBase

@property (nonatomic, strong) NSString *activityId;

@property (nonatomic, strong) GNActivityDetailsModel *detailsModel;
@property (nonatomic, strong) GNVMResponse *getActivityDataResponse;
@property (nonatomic, strong) GNVMResponse *applyResultResponse;
@property (nonatomic, strong) GNVMResponse *getOrderInfoResponse;

@property (nonatomic, strong) NSArray *applyInfo;

@end
