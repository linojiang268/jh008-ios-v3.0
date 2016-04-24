//
//  GNActivitySearchSignInVM.h
//  GatherNew
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNActivitySearchSignInVM : GNVMBase

@property(nonatomic, assign) NSInteger activityId;

@property(nonatomic, assign) NSString * search;

@property (nonatomic, strong) NSMutableArray *searchList;

@property(nonatomic, strong) GNVMResponse * getSearchSignInListResponse;

@end
