//
//  GNGetAuthCodeNPS.m
//  GatherNew
//  注册（吴丹枫）
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNGetAuthCodeNPS.h"

@implementation GNGetAuthCodeNPS

+ (instancetype)NPSWithPhoneNumber:(NSString *)phoneNumber type:(GNGetAuthCodeType)type {
    
    NSString *url = @"/api/register/verifycode";
    if (type == GNGetAuthCodeTypeForgetPassword) {
        url = @"/api/password/reset/verifycode";
    }
    
    GNGetAuthCodeNPS *nps = [[GNGetAuthCodeNPS alloc] initWithURL:url parameters:@{@"mobile":phoneNumber}];
    nps.phoneNumber = phoneNumber;
    
    return nps;
}

@end
