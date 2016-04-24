//
//  GNMapNPS.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/24.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"

@interface GNMapNPS : GNNPSBase

@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@property (nonatomic, assign) long dist;

+ (instancetype)NPSWithlat:(float)lat lng:(float)lng dist:(long)dist;

@end



@interface GNMapPersonNPS : GNNPSBase

@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@property (nonatomic, assign) NSString *activityID;

+ (instancetype)NPSWithActivityID:(NSString *)activityID lat:(float)lat lng:(float)lng;

@end