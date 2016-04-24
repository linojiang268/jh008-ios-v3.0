//
//  GNActivityDetailsModel.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/22.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"
#import "GNActivitySignInModel.h"

typedef NS_ENUM(NSInteger, GNApplyStatus) {
    GNApplyStatusInvalid        = -1,
    GNApplyStatusNormal         = 0,
    GNApplyStatusInReview       = 1,
    GNApplyStatusWaitingPay     = 2,
    GNApplyStatusSuccess        = 3,
    GNApplyStatusPayTimeout     = 4
};

@class GNTeamDetails,GNCityDetails,GNActivityDetails;
@interface GNActivityDetailsModel : GNModelBase

@property (nonatomic, strong) GNActivityDetails *activity;

@property (nonatomic, assign) NSInteger code;

@end

@interface GNActivityDetails : NSObject

@property (nonatomic, strong) GNTeamDetails *team;

@property (nonatomic, strong) NSArray *location;

@property (nonatomic, assign) NSInteger essence;

@property (nonatomic, assign) NSInteger enrolled_num;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *begin_time;

@property (nonatomic, assign) NSInteger enroll_limit;

@property (nonatomic, assign) NSInteger enroll_fee_type;

@property (nonatomic, copy) NSArray *enroll_attrs;

@property (nonatomic, copy) NSString *cover_uri;

@property (nonatomic, strong) GNCityDetails *city;

@property (nonatomic, copy) NSString *publish_time;

@property (nonatomic, copy) NSString *enroll_end_time;

@property (nonatomic, assign) BOOL enrolled_team;

@property (nonatomic, assign) NSInteger enroll_type;

@property (nonatomic, strong) NSArray *roadmap;

@property (nonatomic, copy) NSString *brief_address;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger sub_status;

@property (nonatomic, copy) NSString *enroll_begin_time;

@property (nonatomic, assign) NSInteger update_step;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, strong) NSString *enroll_fee;

@property (nonatomic, assign) NSInteger team_id;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSArray *images_url;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, assign) GNApplyStatus applicant_status;

@property (nonatomic, assign) NSInteger activity_members_count;

@property (nonatomic, assign) NSInteger activity_album_count;

@property (nonatomic, assign) NSInteger activity_file_count;

@property (nonatomic, strong) NSArray *activity_check_in_list;

@property (nonatomic, strong) NSArray *activity_plans;

@property (nonatomic, strong) NSArray *organizers;

@end

@interface GNTeamDetails : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *logo_url;

@end

@interface GNCityDetails : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@end

@interface GNActivityFlowModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *plan_text;
@property (nonatomic, strong) NSString *begin_time;
@property (nonatomic, strong) NSString *end_time;

@end
