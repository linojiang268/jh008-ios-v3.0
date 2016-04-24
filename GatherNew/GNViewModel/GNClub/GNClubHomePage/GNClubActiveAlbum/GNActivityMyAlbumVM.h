//
//  GNActivityMyAlbumVM.h
//  GatherNew
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNActivityAlbumModel.h"

@interface GNActivityMyAlbumVM : GNVMBase

- (instancetype)initWithActivityId:(NSUInteger)activityId;

@property (nonatomic, assign) NSUInteger activityId;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) BOOL loading;

@property (nonatomic, strong) NSMutableArray *albumArray;

@property (nonatomic, strong) GNVMResponse *refreshResponse;
@property (nonatomic, strong) GNVMResponse *deleteResponse;
@property (nonatomic, assign) NSUInteger deletePhotoIndex;
- (void)deletePhotoWithIndex:(NSInteger)index;

@end
