//
//  GNMainBannerModel.h
//  GatherNew
//
//  Created by apple on 15/9/19.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@interface GNMainBannerListModel : GNModelBase

@property (nonatomic, strong) NSArray *banners;

@end


@interface GNMainBannerItemModel : GNModelBase

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *attributes;

@end
