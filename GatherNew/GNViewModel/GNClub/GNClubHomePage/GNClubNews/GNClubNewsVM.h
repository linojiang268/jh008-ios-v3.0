//
//  GNClubNewsVM.h
//  GatherNew
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNClubNewsModel.h"

@interface GNClubNewsVM : GNVMBase

@property (nonatomic, assign) NSUInteger clubId;
@property (nonatomic, assign) NSUInteger page;

- (instancetype)initWithClubId:(NSUInteger)clubId;

@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) GNVMResponse *refreshResponse;

@end
