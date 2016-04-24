//
//  UIViewController+GNExtension.h
//  GatherNew
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNUI : UIStoryboard

+ (GNUI *)meUI;
+ (GNUI *)loginUI;
+ (GNUI *)clubUI;
+ (GNUI *)publicUI;

@end

@interface UIViewController (GNExtension)

/// 适用于有基类
+ (UIStoryboard *)storyboard;
+ (NSString *)sbIdentifier;
+ (instancetype)loadFromStoryboard;
+ (instancetype)loadFromStoryboardWithSbIdentifier:(NSString *)sbIdentifier;

/// 不局限于基类
+ (instancetype)loadFromGNUI:(GNUI *)GNUI;

@end

