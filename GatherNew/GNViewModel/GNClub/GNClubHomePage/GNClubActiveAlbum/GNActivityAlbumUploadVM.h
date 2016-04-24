//
//  GNActivityAlbumUploadVM.h
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNActivityAlbumUploadVM : GNVMBase

@property (nonatomic, assign) NSUInteger activityId;
- (instancetype)initWithActivityId:(NSUInteger)activityId;

@property (nonatomic, strong) NSMutableArray *photosArray;

@property (nonatomic, assign, readonly) BOOL isEnd;
@property (nonatomic, strong) GNVMResponse *uploadResponse;

@end
