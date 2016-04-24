//
//  GNLogService.m
//  GatherNew
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLogService.h"

@implementation GNLogService

+ (void)initService {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

@end
