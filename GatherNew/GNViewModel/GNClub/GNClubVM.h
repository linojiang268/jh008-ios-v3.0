//
//  GNClubVM.h
//  GatherNew
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNClubListModel.h"

@interface GNClubVM : GNVMBase

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) NSMutableArray *clubArray;
@property (nonatomic, strong) GNVMResponse *refreshResponse;

@end
