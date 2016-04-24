//
//  GNActivitySignInVM.h
//  GatherNew
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNActivitySignInModel.h"

@interface GNActivitySignInVM : GNVMBase

@property (nonatomic, strong) NSString *signInIdentifier;
- (instancetype)initWithSignInIdentifier:(NSString *)identifier;

@property (nonatomic, assign) NSUInteger activityId;

@property (nonatomic, strong) GNActivitySignInModel *signInInfo;
@property (nonatomic, strong) GNVMResponse *signInInfoResponse;

/// 签到动作响应
@property (nonatomic, strong) GNVMResponse *signInResponse;

@end
