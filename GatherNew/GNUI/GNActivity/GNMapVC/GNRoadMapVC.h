//
//  GNRoadMapVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/22.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseVC.h"
#import "GNActivityDetailsModel.h"

@interface GNRoadMapVC : GNActivityBaseVC
@property (nonatomic, assign) GNActivityDetails *activityDetails;

- (instancetype)initRoadArray:(NSArray *)arrayRoadLine;
@end
