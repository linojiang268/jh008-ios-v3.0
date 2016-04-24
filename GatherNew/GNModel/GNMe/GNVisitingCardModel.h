//
//  GNVisitingCardModel.h
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@interface GNVisitingCardModel : GNModelBase

@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, assign) GNGender gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSArray *tag_ids;
@property (nonatomic, strong) NSURL *avatar_url;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) NSInteger user_id;

@end
