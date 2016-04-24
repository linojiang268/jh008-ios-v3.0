//
//  GNModelBase.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@implementation GNModelBase

+ (NSString *)localCacheIdentifier {
    return NSStringFromClass([self class]);
}

@end
