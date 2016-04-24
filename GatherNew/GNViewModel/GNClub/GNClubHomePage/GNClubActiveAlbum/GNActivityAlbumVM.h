//
//  GNActivityAlbumVM.h
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNActivityAlbumModel.h"

typedef NS_ENUM(NSUInteger, GNActivityAlbumType) {
    GNActivityAlbumTypeUser     = 1,
    GNActivityAlbumTypeSponsor  = 0,
};

@interface GNActivityAlbumVM : GNVMBase

- (instancetype)initWithType:(GNActivityAlbumType)type
                  activityId:(NSUInteger)activityId;

@property (nonatomic, assign) GNActivityAlbumType type;
@property (nonatomic, assign) NSUInteger activityId;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) BOOL loading;

@property (nonatomic, strong) NSMutableArray *albumArray;

@property (nonatomic, strong) GNVMResponse *refreshResponse;

@end
