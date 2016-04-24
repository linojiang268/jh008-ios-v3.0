//
//  GNMeActivityListVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

//[@"全部", @"待确认",@"即将开始",@"进行中",@"已结束"]
typedef NS_ENUM(NSInteger, GNMeActivityListType) {
    GNMeActivityListType_All                = 1,
    GNMeActivityListType_NotBeginning       = 2,
    GNMeActivityListType_WaitPay            = 3,
    GNMeActivityListType_End                = 4,
    GNMeActivityListType_Auditing           = 5,
    GNMeActivityListType_Beginning          = 6,
    GNMeActivityListType_Pending_Confirm    = 7,
};

@interface GNMeActivityListVM : GNVMBase

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *activityArray;
@property (nonatomic, strong) NSMutableArray *activityDateArray;

@property (nonatomic, assign)GNMeActivityListType activityListType;

@property (nonatomic, strong) GNVMResponse *getActivityListReponese;

@end
