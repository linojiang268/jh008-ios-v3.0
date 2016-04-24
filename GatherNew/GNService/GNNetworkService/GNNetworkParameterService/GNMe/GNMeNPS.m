//
//  GNMeNPS.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeNPS.h"

@implementation GNMeNPS

+ (instancetype)NPSWithClubCity:(NSUInteger)cityId isCount:(BOOL)flag{
        GNMeNPS *nps = [[GNMeNPS alloc]initWithURL:@"/api/team/relate/list" parameters:@{@"city":[NSNumber numberWithInteger:cityId],
                                                                                        @"only_count":[NSNumber numberWithBool:flag]}];

    
    return nps;
}

@end


@implementation GNMeActivityNPS

+ (instancetype)NPSWithActivityNumber{
    return [[GNMeActivityNPS alloc]initWithURL:@"/api/activity/my/count" parameters:nil];
}

@end

@implementation GNMeClubListNPS

+ (instancetype)NPSWithClubCity:(NSUInteger)cityId isCount:(BOOL)flag{
    //    GNMeNPS *nps = [[GNMeNPS alloc]initWithURL:@"/api/team/relate/list" parameters:@{@"city":[NSNumber numberWithInteger:cityId],
    //                                                                                    @"only_count":[NSNumber numberWithBool:flag]}];
    GNMeClubListNPS *nps = [[GNMeClubListNPS alloc]initWithURL:@"/api/team/relate/list"
                                    parameters:@{@"city":[NSNumber numberWithInteger:cityId],
                                                 @"only_count":[NSNumber numberWithBool:flag]}
                             mappingModelClass:NSClassFromString(@"GNMeClubListModel")];
    
    return nps;
}

@end

@implementation GNMeActivityListNPS

+ (instancetype)NPSWithActivityType:(NSString *)type page:(NSInteger)page{
    
//    return [[self alloc]initWithURL:@"/api/activity/my" parameters:@{@"type":type} mappingModelClass:NSClassFromString(@"GNActivityListModel")];
    return [[GNMeActivityListNPS alloc] initWithURL:@"/api/activity/my"
                                           parameters:@{@"type":type, @"page": kNumber(page)}
                                    mappingModelClass:NSClassFromString(@"GNActivityListModel")];
}

@end