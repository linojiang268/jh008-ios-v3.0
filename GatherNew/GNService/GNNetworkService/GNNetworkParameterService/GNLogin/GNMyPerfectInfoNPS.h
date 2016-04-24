//
//  GNMyPerfectInfoNPS.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginNPS.h"

@interface GNMyPerfectInfoNPS : GNNPSBase

@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *nick_name;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSArray *tagIds;
@property (nonatomic,strong) NSString *avatar_url;

+ (instancetype)NPSInit;
@end
