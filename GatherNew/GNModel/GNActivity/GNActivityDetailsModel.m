//
//  GNActivityDetailsModel.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/22.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityDetailsModel.h"

@implementation GNActivityDetailsModel

@end

@implementation GNActivityDetails

+ (NSDictionary *)objectClassInArray {
    return @{@"activity_check_in_list": @"GNActivitySignInItemModel",
             @"activity_plans": @"GNActivityFlowModel"};
}

@end

@implementation GNTeamDetails

@end

@implementation GNCityDetails

@end

@implementation GNActivityFlowModel

@end
