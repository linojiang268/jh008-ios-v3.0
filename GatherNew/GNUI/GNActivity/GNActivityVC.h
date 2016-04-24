//
//  GNActivityVC.h
//  GatherNew
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTableVCBase.h"
#import "GNActivityVM.h"

@interface GNActivityVC : GNTableVCBase

@property (nonatomic, strong) GNActivityVM *viewModel;
- (instancetype)initWithViewModel:(GNActivityVM *)viewModel;

@end
