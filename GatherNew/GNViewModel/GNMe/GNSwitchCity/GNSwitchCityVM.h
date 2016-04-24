//
//  GNSwitchCityVM.h
//  GatherNew
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNCityModel.h"

@interface GNSwitchCityVM : GNVMBase

@property (nonatomic, strong) GNCitiesModel *model;
@property (nonatomic, strong) GNVMResponse *cityResponse;
- (void)switchCity:(GNCityModel *)model;

@end
