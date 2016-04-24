//
//  GNMapPersonModel.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@class GNMembers;
@interface GNMapPersonModel : GNModelBase

@property (nonatomic, strong) NSArray *members;

@property (nonatomic, assign) NSInteger code;


@end


@interface GNMembers : NSObject

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *avatar_url;

@property (nonatomic, assign) double lat;

@property (nonatomic, assign) double lng;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger role;


@end
