//
//  GNMeNPS.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"

@interface GNMeNPS : GNNPSBase

+ (instancetype)NPSWithClubCity:(NSUInteger)cityId isCount:(BOOL)flag;

@end


@interface GNMeActivityNPS : GNNPSBase

+ (instancetype)NPSWithActivityNumber;

@end

@interface GNMeClubListNPS : GNNPSBase

+ (instancetype)NPSWithClubCity:(NSUInteger)cityId isCount:(BOOL)flag;

@end

@interface GNMeActivityListNPS : GNNPSBase

+ (instancetype)NPSWithActivityType:(NSString *)type page:(NSInteger)page;

@end