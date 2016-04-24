//
//  GNActivityListModel.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityListModel.h"

@implementation GNActivityListModel

+ (NSString *)localCacheIdentifier {
        return @"activity_list";
}

+ (NSDictionary *)objectClassInArray{
    return @{@"activities":[GNActivities class]};
}

@end



@implementation GNActivities

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"logo_url"]) {
        return [NSURL URLWithString:oldValue];
    }else if ([property.name isEqualToString:@"qr_code_url"]) {
        return [NSURL URLWithString:oldValue];
    }
    return oldValue;
}

@end

@implementation GNCity

@end

@implementation GNTeam

@end

