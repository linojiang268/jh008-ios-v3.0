//
//  GNRecentActivityNPS.m
//  GatherNew
//
//  Created by yuanjun on 15/9/18.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNRecentActivityNPS.h"

@implementation GNRecentActivityNPS

+ (instancetype)NPSWithNoneParams{
    return [[GNRecentActivityNPS alloc]initWithURL:@"/api/activity/home/my" parameters:nil mappingModelClass:NSClassFromString(@"GNActivityListModel")];
}


@end
