//
//  GNClubListModel.h
//  GatherNew
//
//  Created by apple on 15/7/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

typedef NS_ENUM(NSInteger, GNClubJoinStatus) {
    GNClubJoinStatusNotJoin         = 0,
    GNClubJoinStatusWaitingReview   = 1,
    GNClubJoinStatusHasBeenJoined   = 2,
};

typedef NS_ENUM(NSUInteger, GNClubJoinRequirement) {
    GNClubJoinRequirementNotReview  = 0,
    GNClubJoinRequirementNeedReview = 1,
};

typedef NS_ENUM(NSUInteger, GNClubRertificationStatus) {
    GNClubRertificationStatusNot                = 0,
    GNClubRertificationStatusIn                 = 1,
    GNClubRertificationStatusHasBeenCertified   = 2,
};

@class GNClubDetailModel;
@interface GNClubListModel : GNModelBase

@property (nonatomic, strong) NSArray *teams;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger pages;

@end

@interface GNClubDetailModel : GNModelBase

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *introduction;

/// 社团认证：0未认证，1认证中，2已认证
@property (nonatomic, assign) NSInteger certification;

@property (nonatomic, strong) NSString *logo_url;

@property (nonatomic, strong) NSString *qr_code_url;

/// 社团加入条件设置：0任何人，1需审核
@property (nonatomic, assign) NSInteger join_type;

/// 加入社团验证信息
@property (nonatomic, strong) NSArray *join_requirements;

@property (nonatomic, assign) NSInteger activity_num;

@property (nonatomic, assign) NSInteger member_num;

@property (nonatomic, assign) BOOL joined;

@property (nonatomic, assign) BOOL requested;

@property (nonatomic, assign) BOOL in_whitelist;

@property (nonatomic, assign) BOOL in_blacklist;

@property (nonatomic, assign) NSTimeInterval activities_updated_at;

@property (nonatomic, assign) NSTimeInterval members_updated_at;

@property (nonatomic, assign) NSTimeInterval news_updated_at;

@property (nonatomic, assign) NSTimeInterval albums_updated_at;

@property (nonatomic, assign) NSTimeInterval notices_updated_at;

/// 是否需要输入信息
@property (nonatomic, assign, readonly) BOOL isNeedInputInfo;

/// 隐私设置：0所有人可见，1仅社团成员可见
@property (nonatomic, assign) NSInteger visibility;

@property (nonatomic, assign) NSInteger code;

@end

@interface GNClubJoinRequirementModel : GNModelBase

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *requirement;

@end




