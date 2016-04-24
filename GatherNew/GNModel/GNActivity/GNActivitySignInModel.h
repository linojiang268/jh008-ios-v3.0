//
//  GNActivitySignInModel.h
//  GatherNew
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@interface GNActivitySignInModel : GNModelBase

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger activity_id;
@property (nonatomic, strong) NSString *activity_title;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, strong) NSString *ver;
@property (nonatomic, strong) NSArray *check_list;

/// 签到接口 才返回
@property (nonatomic, strong) NSString *message;

@end

@interface GNActivitySignInItemModel: GNModelBase

@property (nonatomic, assign) NSInteger step;

/// 0：未签订，1：已签到
@property (nonatomic, assign) NSInteger status;

@end