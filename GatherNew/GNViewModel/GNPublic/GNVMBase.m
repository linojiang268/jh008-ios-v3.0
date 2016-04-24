//
//  GNVMBase.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@implementation GNVMBase

- (void)dealloc {
    DDLogError(@"dealloc %@",NSStringFromClass([self class]));
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initModel];
    }
    return self;
}

- (void)initModel {
    
}

@end
