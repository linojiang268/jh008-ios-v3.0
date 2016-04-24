//
//  GNClubListModel.m
//  GatherNew
//
//  Created by apple on 15/7/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubListModel.h"

@implementation GNClubListModel

+ (NSString *)localCacheIdentifier {
    return @"club_list";
}

+ (NSDictionary *)objectClassInArray {
    return @{@"teams": @"GNClubDetailModel"};
}

@end

@implementation GNClubDetailModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.join_type = kGNInvalidCode;
    }
    return self;
}

+ (NSDictionary *)objectClassInArray {
    return @{@"join_requirements": @"GNClubJoinRequirementModel"};
}

- (BOOL)isNeedInputInfo {
    return self.join_requirements.count > 0;
}

@end

@implementation GNClubJoinRequirementModel

@end

