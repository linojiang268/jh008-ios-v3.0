//
//  GNUpdatePerfectInfoNPS.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/13.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMyPerfectInfoNPS.h"

@interface GNUpdatePerfectInfoNPS : GNMyPerfectInfoNPS

@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *password;


+ (instancetype)NPSWithPassword:(NSString *)password
                              name:(NSString *)name
                               sex:(GNGender)sex
                               age:(NSString *)age
                            tagids:(NSArray *)tagids
                      headPortrait:(NSData *)headPortrait;
@end
