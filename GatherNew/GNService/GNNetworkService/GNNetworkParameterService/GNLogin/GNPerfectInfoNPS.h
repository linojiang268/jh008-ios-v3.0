//
//  GNPerfectInfoNPS.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"

@interface GNPerfectInfoNPS : GNNPSBase

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) GNGender sex;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSData *headPortrait;

@property (nonatomic, strong) NSArray *tagIds;

+ (instancetype)NPSWithPhoneNumber:(NSString *)phoneNumber
                          password:(NSString *)password
                              name:(NSString *)name
                               sex:(GNGender)sex
                               age:(NSString *)age
                      headPortrait:(NSData *)headPortrait
                            tagIds:(NSArray *)tagIds;
@end
