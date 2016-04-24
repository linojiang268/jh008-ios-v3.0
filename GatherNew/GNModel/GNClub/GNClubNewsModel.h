//
//  GNClubNewsModel.h
//  GatherNew
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@interface GNClubNewsListModel : GNModelBase

@property (nonatomic, strong) NSArray *news;
@property (nonatomic, assign) NSUInteger pages;
@property (nonatomic, assign) NSInteger code;

@end

@interface GNClubNewsModel : GNModelBase

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *publish_time;
/// 没用
@property (nonatomic, strong) NSString *url;


@end