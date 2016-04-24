//
//  GNMenuOptionVC.h
//  GatherNew
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTableVCBase.h"

@interface GNMenuOptionVC : GNTableVCBase

- (instancetype)initWithOptions:(NSArray *)options;

- (void)autoShowOrHide;

- (void)didSelectOption:(void(^)(NSUInteger index))block;

@end
