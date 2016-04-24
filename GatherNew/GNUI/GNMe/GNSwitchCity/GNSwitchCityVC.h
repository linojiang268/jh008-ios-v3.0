//
//  GNSwitchCityVC.h
//  GatherNew
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTableVCBase.h"

@interface GNSwitchCityVC : GNTableVCBase

- (instancetype)initWithBackEnabled:(BOOL)backEnabled block:(void(^)(GNCityModel *model))block;

@end
