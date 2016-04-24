//
//  GNMemberVC.h
//  GatherNew
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNCollectionVCBase.h"
#import "GNMemberVM.h"

@interface GNMemberVC : GNCollectionVCBase

- (instancetype)initWithType:(GNMemberType)type
                      typeId:(NSUInteger)typeId;

@end
