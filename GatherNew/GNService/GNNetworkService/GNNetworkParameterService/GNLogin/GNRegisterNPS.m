//
//  GNRegisterNPS.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNRegisterNPS.h"

@implementation GNRegisterNPS

+ (instancetype)NPSWithPhoneNumber:(GNPerfectInfoNPS *)perfectInfo
                              code:(NSString *)code;
{
    GNRegisterNPS *nps =[[GNRegisterNPS alloc] initWithURL:@"/api/register"];
    nps.perfectInfo  = perfectInfo;
    nps.code = code;
    
    [nps setFormData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:perfectInfo.headPortrait name:@"avatar" fileName:@"img.jpg" mimeType:@"image/jpg"];
    }];
    
    return nps;
}

- (void)assemblyParameters {
    self.parameters = [NSMutableDictionary dictionary];

    [self.parameters setObject:self.perfectInfo.phoneNumber forKey:@"mobile"];
    [self.parameters setObject:self.perfectInfo.passWord forKey:@"password"];
    [self.parameters setObject:self.code forKey:@"code"];
    [self.parameters setObject:self.perfectInfo.name forKey:@"nick_name"];
    [self.parameters setObject:[NSString stringWithFormat:@"%ld", (long)self.perfectInfo.sex]  forKey:@"gender"];
    [self.parameters setObject:self.perfectInfo.age forKey:@"birthday"];
    [self.parameters setObject:[self createSign:self.parameters] forKey:@"sign"];
    [self.parameters setObject:self.perfectInfo.tagIds forKey:@"tagIds"];
}


@end
