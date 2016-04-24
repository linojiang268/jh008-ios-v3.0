//
//  GNExistNPS.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/13.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNExistNPS.h"

@implementation GNExistNPS
+ (instancetype)NPSInit{
    GNExistNPS *nps = [[GNExistNPS alloc]initWithURL:@"/api/logout"];
    return nps;
}
@end
