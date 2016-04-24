//
//  GNMapVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/24.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNMapVM : GNVMBase
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) NSInteger dist;
@property (nonatomic, strong) NSString *activityID;

@property (nonatomic, strong) NSArray *arrayMembers;

@property (nonatomic, strong) GNVMResponse *getLocationActivityResponse;

@property (nonatomic, strong) GNVMResponse *getActivityPersonResponse;
@end
