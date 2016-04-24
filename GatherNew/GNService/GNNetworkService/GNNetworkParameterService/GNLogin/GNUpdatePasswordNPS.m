//
//  GNUpdatePasswordNPS.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNUpdatePasswordNPS.h"

@implementation GNUpdatePasswordNPS
+ (instancetype)NPSWithPhoneNumber:(NSString *)phoneNumber
                          password:(NSString *)password
                              code:(NSString *)code
                             token:(NSString *)token
{
    GNUpdatePasswordNPS *nps =[[GNUpdatePasswordNPS alloc] initWithURL:@"/api/password/reset"];
    nps.phoneNumber = phoneNumber;
    nps.password = password;
    nps.code = code;
    nps.token = token;
    
    
    return nps;
}

- (void)assemblyParameters {
    self.parameters = [NSMutableDictionary dictionary];
    [self.parameters setObject:self.phoneNumber forKey:@"mobile"];
    [self.parameters setObject:self.password forKey:@"password"];
    [self.parameters setObject:self.code forKey:@"code"];
    [self.parameters setObject:self.token forKey:@"_token"];
    [self.parameters setObject:[self createSign:self.parameters] forKey:@"sign"];
    
}
@end

@implementation GNTokenNPS
+ (instancetype)NPSWithPhoneNumber
{
    GNTokenNPS *nps =[[GNTokenNPS alloc] initWithURL:@"/api/password/reset"];

    return nps;
}


@end

@implementation GNUpdateOldPasswordNPS
+ (instancetype)NPSWithOldPassword:(NSString *)oldPassword
                       newPassword:(NSString *)newPassword;
{
    GNUpdateOldPasswordNPS *nps = [[GNUpdateOldPasswordNPS alloc]initWithURL:@"/api/password/change"];
    
    nps.oldPassword = oldPassword;
    nps.nPassword = newPassword;
    
    return nps;
}

- (void)assemblyParameters {
    
    self.parameters = [NSMutableDictionary dictionary];
    [self.parameters setObject:self.oldPassword forKey:@"original_password"];
    [self.parameters setObject:self.nPassword forKey:@"new_password"];
 
    [self.parameters setObject:[self createSign:self.parameters] forKey:@"sign"];
    
}

@end