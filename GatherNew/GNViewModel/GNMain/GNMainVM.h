//
//  GNMainVM.h
//  GatherNew
//
//  Created by yuanjun on 15/9/18.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNActivityListModel.h"
#import "GNMainBannerModel.h"
#import "GNClubListModel.h"

@interface GNMainVM : GNVMBase

@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *clubArray;
@property (nonatomic, strong) NSMutableArray *activityArray;

@property (nonatomic, strong) GNVMResponse *refreshResponse;

@end
