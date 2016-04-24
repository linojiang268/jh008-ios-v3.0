//
//  GNActivityAlbumUploadVC.h
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNCollectionVCBase.h"

@interface GNActivityAlbumUploadVC : GNCollectionVCBase

- (instancetype)initWithActivityId:(NSUInteger)activityId;

- (void)uploadComplete:(void(^)(void))block;

@end
