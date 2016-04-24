//
//  GNUpdatePerfectInfoModel.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/13.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNPerfectInfoModel.h"

@implementation GNPerfectInfoModel

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"avatar_url"]) {
        return [NSURL URLWithString:oldValue];
    }
    return oldValue;
}

@end
