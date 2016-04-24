//
//  UINavigationBar+GNExtension.m
//  GatherNew
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "UINavigationBar+GNExtension.h"

@implementation UINavigationBar (GNExtension)

- (void)lineViewHide:(BOOL)hide {
    [((UIView *)self.subviews.firstObject).subviews.lastObject setHidden:hide];
}

@end
