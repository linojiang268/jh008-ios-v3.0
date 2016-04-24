//
//  GNLoginNPS.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"

@interface GNLoginNPS : GNNPSBase

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *password;

+ (instancetype)NPSWithPhoneNumber:(NSString *)phoneNumber
                          password:(NSString *)password;

@end
