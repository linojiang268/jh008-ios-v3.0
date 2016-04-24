//
//  GNActivityVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

typedef NS_ENUM(NSInteger, GNActivityType) {
    GNActivityTypeActivity   = 1,
    GNActivityTypeClub       = 2
};

@interface GNActivityVM : GNVMBase

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, assign) NSUInteger clubId;

@property (nonatomic, assign) GNActivityType activityType;

@property (nonatomic, strong) NSMutableArray *activityArray;
@property (nonatomic, strong) GNVMResponse *refreshActivityResponse;

- (instancetype)initActiveList;
- (instancetype)initClubActiveListWithClubId:(NSUInteger)clubId;

@end
