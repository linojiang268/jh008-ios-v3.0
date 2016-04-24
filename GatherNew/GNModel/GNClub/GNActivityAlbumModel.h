//
//  GNActivityAlbumModel.h
//  GatherNew
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@class GNPhotoModel;
@interface GNActivityAlbumListModel : GNModelBase

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger total_num;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) NSInteger code;

@end

@interface GNPhotoModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSString *image_url;


@end
