//
//  GNMemberVM.h
//  GatherNew
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNMemberModel.h"

typedef NS_ENUM(NSUInteger, GNMemberType) {
    GNMemberTypeClub        = 1,
    GNMemberTypeActivity    = 2,
};

@interface GNMemberVM : GNVMBase

- (instancetype)initWithType:(GNMemberType)type
                      typeId:(NSUInteger)typeId;

@property (nonatomic, strong) NSMutableArray *memberArray;

@property (nonatomic, assign) NSUInteger typeId;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) GNVMResponse *refreshResponse;

@end
