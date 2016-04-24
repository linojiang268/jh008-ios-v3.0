//
//  GNMeClubListModel.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@class GNEnrolled_Teams,GNRecommended_Teams,GNRequested_Teams,GNInvited_Teams;
@interface GNMeClubListModel : GNModelBase

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSArray *enrolled_teams;

@property (nonatomic, strong) NSArray *recommended_teams;

@property (nonatomic, strong) NSArray *requested_teams;

@property (nonatomic, strong) NSArray *invited_teams;

@end

@interface GNEnrolled_Teams : NSObject

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) BOOL joined;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger certification;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, copy) NSString *qr_code_url;

@property (nonatomic, assign) NSInteger activity_num;

@property (nonatomic, assign) NSInteger member_num;

@property (nonatomic, copy) NSString *name;

@end

@interface GNRecommended_Teams : NSObject

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) BOOL joined;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger certification;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, copy) NSString *qr_code_url;

@property (nonatomic, assign) NSInteger activity_num;

@property (nonatomic, assign) NSInteger member_num;

@property (nonatomic, copy) NSString *name;

@end

@interface GNRequested_Teams : NSObject

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) BOOL joined;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger certification;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, copy) NSString *qr_code_url;

@property (nonatomic, assign) NSInteger activity_num;

@property (nonatomic, assign) NSInteger member_num;

@property (nonatomic, copy) NSString *name;

@end


@interface GNInvited_Teams : NSObject

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) BOOL joined;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger certification;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, copy) NSString *qr_code_url;

@property (nonatomic, assign) NSInteger activity_num;

@property (nonatomic, assign) NSInteger member_num;

@property (nonatomic, copy) NSString *name;

@end