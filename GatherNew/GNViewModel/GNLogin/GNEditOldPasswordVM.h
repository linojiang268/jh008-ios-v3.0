//
//  GNEditOldPasswordVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNEditOldPasswordVM : GNVMBase

@property (nonatomic,strong) NSString *oldPassword;
@property (nonatomic,strong) NSString *firstPassword;
@property (nonatomic,strong) NSString *secondPassword;

@property (nonatomic, strong) GNVMResponse *nextResponce;
@property (nonatomic, strong) RACCommand *nextCommand;

@end
