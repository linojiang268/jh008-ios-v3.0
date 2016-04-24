//
//  GNMeClubListVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNMeClubListModel.h"

@interface GNMeClubListVM : GNVMBase

@property (nonatomic, strong) GNMeClubListModel *clubListModel;

@property (nonatomic, strong) GNVMResponse *getClubListResponse;

@end
