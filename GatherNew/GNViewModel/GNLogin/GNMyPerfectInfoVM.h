//
//  GNMyPerfectInfoVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNPerfectInfoModel.h"

@interface GNMyPerfectInfoVM : GNVMBase

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) GNGender sex;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) UIImage *headPortrait;
@property (nonatomic, strong) NSArray *arrayTag;

@property (nonatomic, strong) RACCommand *saveCommand;

@property (nonatomic, strong) GNVMResponse *existResponse;
@property (nonatomic, strong) GNVMResponse *saveResponse;

@property (nonatomic, strong) GNVMResponse *getPerfectInfoResponse;
@end
