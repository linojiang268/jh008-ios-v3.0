//
//  GNLoginVM.h
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNLoginVM : GNVMBase

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) GNVMResponse *loginResponse;



-(void)silenceLogin;

@end
