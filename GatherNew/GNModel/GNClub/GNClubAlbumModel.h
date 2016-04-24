//
//  GNClubAlbumModel.h
//  GatherNew
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@class GNClubAlbumItemModel;
@interface GNClubAlbumListModel : GNModelBase

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, strong) NSArray *activities;

@property (nonatomic, assign) NSInteger code;

@end

@interface GNClubAlbumListItemModel : NSObject

@property (nonatomic, strong) NSString *begin_time;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *publish_time;

@property (nonatomic, strong) NSString *end_time;


@end


