//
//  GNUpdatePerfectInfoNPS.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/13.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNUpdatePerfectInfoNPS.h"
#import "NSString+GNExtension.h"

@implementation GNUpdatePerfectInfoNPS

+ (instancetype)NPSWithPassword:(NSString *)password
                           name:(NSString *)name
                            sex:(GNGender)sex
                            age:(NSString *)age
                         tagids:(NSArray *)tagids
                   headPortrait:(NSData *)headPortrait
{
    GNUpdatePerfectInfoNPS *nps = [[GNUpdatePerfectInfoNPS alloc] initWithURL:@"/api/user/profile/complete"];
    nps.password = password;
    nps.nick_name = name;
    nps.gender = [NSString stringWithFormat:@"%d",sex];
    nps.birthday = age;
    nps.tagIds = tagids;
    if (headPortrait != nil) {
        [nps setFormData:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:headPortrait name:@"avatar" fileName:@"img.jpg" mimeType:@"image/jpg"];
        }];
    }

    return nps;
}

- (void)assemblyParameters {
    self.parameters = [NSMutableDictionary dictionary];
    
    if (self.password!=nil&&self.password.length>0&&![self.password isEqualToString:@"123456"]) {
        [self.parameters setObject:self.password forKey:@"password"];
    }
    if (self.nick_name!=nil&&self.nick_name.length>0) {
        [self.parameters setObject:self.nick_name forKey:@"nick_name"];
    }
    if (self.gender!=nil&&self.gender.length>0) {
        [self.parameters setObject:self.gender forKey:@"gender"];
    }
    if (self.birthday!=nil&&self.birthday.length>0) {
        [self.parameters setObject:self.birthday forKey:@"birthday"];
    }
    [self.parameters setObject:[self createSign:self.parameters] forKey:@"sign"];
    if (self.tagIds!=nil&&self.tagIds.count>0) {
        [self.parameters setObject:self.tagIds forKey:@"tagIds"];
    }
    else{
        [self.parameters setObject:@[@"1",@"2"] forKey:@"tagIds"];//测试数据
    }
}


@end
