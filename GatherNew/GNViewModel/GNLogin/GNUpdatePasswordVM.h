//
//  GNUpdatePasswordVM.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNUpdatePasswordVM : GNVMBase

@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *token;

@property (nonatomic, strong) NSString *getAuthCodeTitle;

@property (nonatomic, strong) RACCommand *getAuthCodeCommand;
@property (nonatomic, strong) RACCommand *nextCommand;

@end
