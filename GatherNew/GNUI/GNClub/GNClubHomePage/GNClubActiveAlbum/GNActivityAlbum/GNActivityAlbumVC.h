//
//  GNActivityAlbumVC.h
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNCollectionVCBase.h"
#import "GNActivityAlbumVM.h"

@interface GNActivityAlbumVC : GNCollectionVCBase

- (instancetype)initWithType:(GNActivityAlbumType)type
                  activityId:(NSUInteger)activityId;

- (void)prepareRefresh;

@end
