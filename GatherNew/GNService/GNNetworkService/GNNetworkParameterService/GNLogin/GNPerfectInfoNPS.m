//
//  GNPerfectInfoNPS.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNPerfectInfoNPS.h"

@implementation GNPerfectInfoNPS

+ (instancetype)NPSWithPhoneNumber:(NSString *)phoneNumber
                          password:(NSString *)password
                              name:(NSString *)name
                               sex:(GNGender)sex
                               age:(NSString *)age
                      headPortrait:(NSData *)headPortrait
                            tagIds:(NSArray *)tagIds
{
    GNPerfectInfoNPS *perfectInfo = [[GNPerfectInfoNPS alloc]init];
    perfectInfo.phoneNumber = phoneNumber;
    perfectInfo.passWord = password;
    perfectInfo.name = name;
    perfectInfo.sex = sex;
    perfectInfo.age = age;
    perfectInfo.headPortrait = headPortrait;
    perfectInfo.tagIds = tagIds;
   

    return perfectInfo;
}

@end
