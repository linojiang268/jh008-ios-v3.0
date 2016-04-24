//
//  GNActivityScoreModel.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"


@class GNActivity;
@class GNRatingRelatedClubModel;
@interface GNActivityScoreModel : GNModelBase

@property (nonatomic, strong) NSArray *activities;

@property (nonatomic, assign) NSInteger code;

@end

@interface GNActivity : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *publish_time;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *begin_time;


/// 新评价
@property (nonatomic, assign) NSInteger team_id;
@property (nonatomic, strong) GNRatingRelatedClubModel *team;
@property (nonatomic, strong) NSArray *location;
@property (nonatomic, assign) NSInteger enrolled_num;
@property (nonatomic, assign) BOOL enrolled_team;


@end

@interface GNRatingRelatedClubModel : GNModelBase

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *logo_url;
@property (nonatomic, strong) NSString *introduction;

@end
