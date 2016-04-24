//
//  GNActivityRatingVC.h
//  GatherNew
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"
#import "GNActivityScoreModel.h"

@interface GNActivityRatingVC : GNVCBase

- (instancetype)initWithActivityModel:(GNActivity *)model;

- (void)finlishRatingWithBlock:(void(^)(void))block;

@end
