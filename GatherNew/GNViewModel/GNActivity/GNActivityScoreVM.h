//
//  GNActivityScoreVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNActivityScoreVM : GNVMBase

@property (nonatomic, assign) NSInteger activity;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic, strong) NSString *memo;

@property (nonatomic, strong) GNVMResponse *getActivityScoreResponse;

@property (nonatomic, strong) GNVMResponse *commitResponse;
@property (nonatomic, strong) RACCommand *commitCommand;
@end
