//
//  GNMapVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseVC.h"
#import "GNActivityDetailsModel.h"

typedef NS_ENUM(NSInteger, GNMapType) {
    GNMapType_AllActivity,
    GNMapType_CurrentActivity
};

@interface GNMapVC : GNActivityBaseVC
//@property (nonatomic, strong) NSString *endName;
//@property (nonatomic, assign) CLLocationCoordinate2D endCoor;
@property (nonatomic, assign) GNMapType mapType;
@property (nonatomic, strong) GNActivityDetails *activityDetails;

@end
