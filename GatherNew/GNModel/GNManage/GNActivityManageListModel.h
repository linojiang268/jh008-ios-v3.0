//
//  GNActivityManageListModel.h
//  GatherNew
//
//  Created by Culmore on 15/10/2.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@interface GNActivityManageListModel : GNModelBase

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, assign) NSInteger total_num;
@property(nonatomic, strong) NSArray* activities;

@end



@interface GNActivityManageModel : GNModelBase

@property(nonatomic, assign) NSInteger id;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, assign) NSInteger enroll_fee_type;
@property(nonatomic, assign) NSInteger auditing;
@property(nonatomic, strong) NSString* begin_time;
@property(nonatomic, strong) NSString* end_time;
@property(nonatomic, assign) NSInteger status;
@property(nonatomic, assign) NSInteger sub_status;

@property (nonatomic, copy) NSArray *enroll_attrs;//在报名管理界面添加手动添加报名的功能

@end