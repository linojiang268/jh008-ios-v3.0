//
//  GNUpdatePerfectInfoModel.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/13.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@interface GNPerfectInfoModel : GNModelBase

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *nick_name;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, strong) NSArray *tag_ids;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSString *birthday;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, strong) NSURL *avatar_url;

@end

