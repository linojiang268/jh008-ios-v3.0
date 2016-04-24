//
//  GNActivityApplyInputInfoVC.h
//  GatherNew
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"

@interface GNActivityApplyInputInfoVC : GNVCBase

- (instancetype)initWithRequirements:(NSArray *)requirements
                       commitHandler:(void(^)(NSArray *info))handler;

@end
