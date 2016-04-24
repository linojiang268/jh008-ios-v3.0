//
//  GNActivityManageAddNewVM.h
//  GatherNew
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNActivityManageAddNewVM : GNVMBase

@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, strong) NSArray *attributes;

@property (nonatomic, strong) GNVMResponse *addNewResponse;

- (instancetype)initWithActivity;

@end
