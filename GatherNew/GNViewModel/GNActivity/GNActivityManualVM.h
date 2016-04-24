//
//  GNActivityManualVM.h
//  GatherNew
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNActivityDetailsModel.h"

@interface GNActivityManualVM : GNVMBase

@property (nonatomic, assign) NSUInteger activityId;
- (instancetype)initWithActivityId:(NSUInteger)activityId;

@property (nonatomic, strong) GNActivityDetailsModel *manualModel;
@property (nonatomic, strong) GNVMResponse *getManualInfoResponse;

@end
