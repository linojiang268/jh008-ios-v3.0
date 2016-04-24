//
//  GNUpdatePasswordNPS.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginNPS.h"

@interface GNUpdatePasswordNPS : GNNPSBase

@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *token;

+ (instancetype)NPSWithPhoneNumber:(NSString *)phoneNumber
                          password:(NSString *)password
                              code:(NSString *)code
                             token:(NSString *)token;

@end

@interface GNTokenNPS : GNNPSBase

+ (instancetype)NPSWithPhoneNumber;

@end


@interface GNUpdateOldPasswordNPS: GNNPSBase

@property (nonatomic,strong) NSString *oldPassword;
@property (nonatomic,strong) NSString *nPassword;


+ (instancetype)NPSWithOldPassword:(NSString *)oldPassword
                       newPassword:(NSString *)newPassword;


@end