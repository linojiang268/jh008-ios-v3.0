//
//  GNRegisterNPS.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginNPS.h"
#import "GNPerfectInfoNPS.h"

@interface GNRegisterNPS : GNLoginNPS

@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)GNPerfectInfoNPS *perfectInfo;

+ (instancetype)NPSWithPhoneNumber:(GNPerfectInfoNPS *)perfectInfo
                              code:(NSString *)code;
@end
