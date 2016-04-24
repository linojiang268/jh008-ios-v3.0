//
//  GNCityModel.h
//  GatherNew
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@class GNCityModel;
@interface GNCitiesModel : GNModelBase

@property (nonatomic, strong) NSArray *cities;

@property (nonatomic, assign) NSInteger code;

@end

@interface GNCityModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSString *name;

@end
