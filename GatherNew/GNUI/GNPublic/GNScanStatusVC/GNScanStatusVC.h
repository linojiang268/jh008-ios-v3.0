//
//  GNScanStatusVC.h
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"

typedef NS_ENUM(NSUInteger, GNScanResultType) {
    GNScanResultTypeNoApply         = 5,
    GNScanResultTypeUnknown         = 6
};

@interface GNScanStatusVC : GNVCBase

+ (GNScanStatusVC *)statusWithType:(GNScanResultType)type backBlock:(void(^)(void))block;;

@end
