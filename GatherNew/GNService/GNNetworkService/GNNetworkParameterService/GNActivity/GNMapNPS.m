//
//  GNMapNPS.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/24.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMapNPS.h"

@implementation GNMapNPS
+ (instancetype)NPSWithlat:(float)lat lng:(float)lng dist:(long)dist{
    GNMapNPS *nsp = [[GNMapNPS alloc]initWithURL:@"/api/activity/search/point"
                                      parameters:@{@"lat":[NSString stringWithFormat:@"%f",lat],
                                                   @"lng":[NSString stringWithFormat:@"%f",lng],
                                                   @"dist":[NSString stringWithFormat:@"%ld",dist]}
                               mappingModelClass:NSClassFromString(@"GNActivityListModel")];
    return nsp;
}
@end



@implementation GNMapPersonNPS
+ (instancetype)NPSWithActivityID:(NSString *)activityID lat:(float)lat lng:(float)lng{
    GNMapPersonNPS *nsp = [[GNMapPersonNPS alloc]initWithURL:@"/api/activity/member/location"
                                      parameters:@{@"lat":kNumber(lat),
                                                   @"lng":kNumber(lng),
                                                   @"activity_id":kNumber([activityID intValue])}
                                           mappingModelClass:NSClassFromString(@"GNMapPersonModel")];
    return nsp;
}
@end