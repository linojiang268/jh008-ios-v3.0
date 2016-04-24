//
//  GNGetAuthCodeNPS.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"

typedef NS_ENUM(NSUInteger, GNGetAuthCodeType) {
    GNGetAuthCodeTypeRegister       = 1,
    GNGetAuthCodeTypeForgetPassword = 2,
};

@interface GNGetAuthCodeNPS : GNNPSBase

@property (nonatomic, strong) NSString *phoneNumber;

+ (instancetype)NPSWithPhoneNumber:(NSString *)phoneNumber type:(GNGetAuthCodeType)type;

@end
