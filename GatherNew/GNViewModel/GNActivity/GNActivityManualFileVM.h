//
//  GNActivityManualFileVM.h
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNActivityManualFileModel.h"

@interface GNActivityManualFileVM : GNVMBase

- (instancetype)initWithActivityId:(NSUInteger)activityId;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *fileArray;
@property (nonatomic, strong) GNVMResponse *refreshResponse;

@end
