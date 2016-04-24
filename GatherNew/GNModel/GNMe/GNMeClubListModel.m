//
//  GNMeClubListModel.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeClubListModel.h"

@implementation GNMeClubListModel


+ (NSDictionary *)objectClassInArray{
    return @{
             @"requested_teams":[GNRequested_Teams class],
             @"recommended_teams":[GNRecommended_Teams class],
             @"enrolled_teams":[GNEnrolled_Teams class],
             @"invited_teams":[GNInvited_Teams class]
             };
}

@end


@implementation GNEnrolled_Teams

@end

@implementation GNRecommended_Teams

@end

@implementation GNRequested_Teams

@end

@implementation GNInvited_Teams

@end