//
//  GNRegisterVM.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNPerfectInfoNPS.h"

@interface GNRegisterVM : GNVMBase

@property (nonatomic, strong) NSString *getAuthCodeTitle;
@property (nonatomic, strong) NSString *inputAuthCode;
//注册

@property (nonatomic, strong) GNPerfectInfoNPS *perfectInfo;

@property (nonatomic, strong) RACCommand *getAuthCodeCommand;
@property (nonatomic, strong) RACCommand *nextCommand;

@property (nonatomic, strong) GNVMResponse *getAuthCodeResponse;
@property (nonatomic, strong) GNVMResponse *nextResponse;

//修改密码
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *passwordNew;

//登陆
@property (nonatomic, strong) GNVMResponse *loginResponse;

- (instancetype)initWithVMType:(GNVMType)vmType;
@end
