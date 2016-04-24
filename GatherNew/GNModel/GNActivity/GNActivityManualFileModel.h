//
//  GNActivityManualFileModel.h
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@interface GNActivityManualFileModel : GNModelBase

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) NSArray *files;

@end


@interface GNActivityManualFileItemModel : GNModelBase

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *extension;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSString *url;

@end