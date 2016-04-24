//
//  GNActivityListModel.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

typedef NS_ENUM(NSInteger, GNActivityStatus){
    GNActivityStatusCreateing      = 1,
    GNActivityStatusApplying       = 2,
    GNActivityStatusInPrepare      = 3,
    GNActivityStatusRunning        = 4,
    GNActivityStatusEnd            = 5
};

typedef NS_ENUM(NSInteger, GNActivityFeeType) {
    GNActivityFeeTypeFee        = 1,
    GNActivityFeeTypeAA         = 2,
    GNActivityFeeTypeToll       = 3
};

typedef NS_ENUM(NSInteger, GNActivityEssence) {
    GNActivityEssenceCommon         = 0,
    GNActivityEssenceEssence        = 1
};

typedef NS_ENUM(NSInteger, GNActivityApplicantInfo) {
    GNActivityApplicantInfoLose         = -1,
    GNActivityApplicantInfoBeginning    = 0,
    GNActivityApplicantInfoChecking     = 1,
    GNActivityApplicantInfoPayment      = 2,
    GNActivityApplicantInfoSuccess      = 3,
    GNActivityApplicantInfoTimeOut      = 4
};

@class GNTeam,GNCity;

@interface GNActivityListModel : GNModelBase

@property (nonatomic, strong) NSArray *activities;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger pages;

@end

@interface GNActivities : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSURL *cover_url;

@property (nonatomic, strong) GNTeam *team;

@property (nonatomic, strong) GNCity *city;

@property (nonatomic, strong) NSArray *location;

@property (nonatomic, assign) NSInteger essence;

@property (nonatomic, assign) NSInteger enrolled_num;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *begin_time;

@property (nonatomic, assign) NSInteger enroll_limit;

@property (nonatomic, assign) NSInteger enroll_fee_type;

@property (nonatomic, copy) NSArray *enroll_attrs;

@property (nonatomic, copy) NSString *cover_uri;


@property (nonatomic, copy) NSString *publish_time;

@property (nonatomic, copy) NSString *enroll_end_time;

@property (nonatomic, assign) BOOL enrolled_team;

@property (nonatomic, assign) NSInteger enroll_type;

@property (nonatomic, strong) NSArray *roadmap;

@property (nonatomic, copy) NSString *brief_address;


@property (nonatomic, assign) NSInteger sub_status;

@property (nonatomic, copy) NSString *enroll_begin_time;

@property (nonatomic, assign) NSInteger update_step;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, strong) NSString *enroll_fee;

@property (nonatomic, assign) NSInteger team_id;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSArray *images_url;

@property (nonatomic, copy) NSString *telphone;

@property (nonatomic, assign) NSInteger applicant_info;

@property (nonatomic, assign) NSInteger applicant_status;

@end

@interface GNTeam : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@end

@interface GNCity : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;


@end
