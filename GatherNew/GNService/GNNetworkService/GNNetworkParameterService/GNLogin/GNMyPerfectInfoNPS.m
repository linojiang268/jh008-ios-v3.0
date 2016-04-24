//
//  GNMyPerfectInfoNPS.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMyPerfectInfoNPS.h"

@implementation GNMyPerfectInfoNPS

+ (instancetype)NPSInit{
    GNMyPerfectInfoNPS *nps = [[GNMyPerfectInfoNPS alloc]initWithURL:@"/api/user/profile"
                                                          parameters:@{@"user_id":[NSString stringWithFormat:@"%ld",(long)[GNApp userId]]}
                                                         requestType:GNNetworkRequestTypeGetCacheAfterRefreshAndCache
                                                   mappingModelClass:NSClassFromString(@"GNPerfectInfoModel")
                                                localCacheIdentifier:@"uesr_info"];
    
    return nps;
}



@end
