//
//  GNActivityLocationCell.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseCell.h"
#import "GNActivityDetailsModel.h"

@interface GNActivityLocationCell : GNActivityBaseCell

@property (strong, nonatomic) NSArray *arrayLocation;

-(void)bindActivity:(GNActivityDetails*)activity;
@end
