//
//  GNActivityManageDetailVC.h
//  GatherNew
//
//  Created by Culmore on 15/10/4.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"

@interface GNActivityManageDetailVC : GNVCBase

@property(nonatomic, assign)NSInteger activityId;
@property(nonatomic, assign)BOOL needAuth;
@property(nonatomic, assign)BOOL needPay;
@property(nonatomic, assign)NSArray * enrollAttrs;
@property(nonatomic, assign)NSInteger subStatus;


+ (instancetype)initWithActivity:(NSUInteger)activityId needAuth:(BOOL)needAuth needPay:(BOOL)needPay enrollAttrs:(NSArray *)enrollAttrs subStatus:(NSInteger)subStatus;


@end
