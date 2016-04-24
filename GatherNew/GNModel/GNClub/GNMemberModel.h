//
//  GNMemberModel.h
//  GatherNew
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@class GNMemberModel;
@interface GNMemberListModel : GNModelBase

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, strong) NSArray *members;

@property (nonatomic, assign) NSInteger code;

@end

@interface GNMemberModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, strong) NSDictionary *group;

@end
