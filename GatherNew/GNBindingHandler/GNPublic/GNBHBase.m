//
//  GNBHBase.m
//  GatherNew
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNBHBase.h"

@implementation GNBHBase

- (instancetype)initWithGNUI:(id)UI {
    self = [super init];
    if (self) {
        self.GNUI = UI;
    }
    return self;
}

+ (instancetype)BHWithGNUI:(id)UI {
    return [[self alloc] initWithGNUI:UI];
}

- (void)binding {
    
}

@end
