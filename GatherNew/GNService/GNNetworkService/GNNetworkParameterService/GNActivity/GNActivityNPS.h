//
//  GNActivityNPS.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"

@interface GNActivityNPS : GNNPSBase

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger size;

+ (instancetype)NPSWithKeyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size;

@end


@interface GNActivitySearchNPS : GNNPSBase

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger size;

+ (instancetype)NPSWithKeyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size;

@end


@interface GNActivityDetailsNPS : GNNPSBase

@property (nonatomic, strong) NSString *activityID;

+ (instancetype)NPSWithActivityID:(NSString *)activityID;

@end

@interface GNActivityScoreNPS : GNNPSBase

+ (instancetype)NPSWithScoreData;


+ (instancetype)NPSWithActivityID:(NSInteger)activityid score:(NSInteger)score attributes:(NSArray *)attributes memo:(NSString *)memo;

@end

#pragma mark -

@interface GNActivityApplyNPS : GNNPSBase

+ (instancetype)NPSWithActivityId:(NSUInteger)activityId info:(NSArray *)info;

@end


@interface GNActivityManageAddNewNPS : GNNPSBase

@property (nonatomic, strong) NSString *activityID;

+ (instancetype)NPSWithActivityID:(NSInteger)activityId attributes:(NSArray *)attributes;

@end


