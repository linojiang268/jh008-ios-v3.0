//
//  GNMessageModel.h
//  GatherNew
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@class GNPrivateMessageModel;
@interface GNPrivateMessageListModel : GNModelBase

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSArray *messages;

@property (nonatomic, strong) NSString *last_requested_time;

@property (nonatomic, assign) NSInteger total_num;

@end

@interface GNPrivateMessageModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *created_at;

@property (nonatomic, strong) NSDictionary *attributes;

@property (nonatomic, strong) NSString * team_name;

@property (nonatomic) NSInteger team_id;

@property (nonatomic) NSInteger activity_id;

@end
