//
//  GNActivityScoreModel.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityScoreModel.h"

@implementation GNActivityScoreModel

+ (NSDictionary *)objectClassInArray {
    return @{@"activities": @"GNActivity"};
}

@end

@implementation GNActivity

+ (NSDictionary *)objectClassInArray {
    return @{@"team": @"GNRatingRelatedClubModel"};
}

@end

@implementation GNRatingRelatedClubModel

@end