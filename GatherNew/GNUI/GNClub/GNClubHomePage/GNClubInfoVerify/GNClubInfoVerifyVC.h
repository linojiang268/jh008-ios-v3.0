//
//  GNClubInfoVerifyVC.h
//  GatherNew
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"

@interface GNClubInfoVerifyVC : GNVCBase

- (instancetype)initWithRequirements:(NSArray *)requirements
                       commitHandler:(void(^)(NSDictionary *requirements))handler;

@end
