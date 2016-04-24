//
//  GNClubStatusVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"



typedef NS_ENUM(NSUInteger, GNClubStatusType) {
    GNClubStatusTypeJoinClubSuccess                                 = 1,
    GNClubStatusTypeJoinClubWaiting                                 = 2,
    GNClubStatusTypeJoinClubNeedPerfectInformation                  = 3,
    GNClubStatusTypeJoinClubWhiteListUserAndNeedPerfectInformation  = 4,
};

@interface GNClubStatusVC : GNVCBase

+ (instancetype)initWithStatusAndAction:(GNClubStatusType)status
                actionHandler:(void(^)(GNClubStatusVC *clubStatusVC))handler;


@end
