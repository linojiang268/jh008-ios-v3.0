//
//  UINavigationController+GNExtension.m
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "UINavigationController+GNExtension.h"

@implementation UINavigationController (GNExtension)

- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController setHidesBottomBarWhenPushed:YES];
    [self pushViewController:viewController animated:animated];
}

@end
