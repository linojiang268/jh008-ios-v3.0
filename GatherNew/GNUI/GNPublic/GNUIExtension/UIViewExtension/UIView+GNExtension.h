//
//  UIView+GNAutoLayoutExtension.h
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GNExtension)

+ (UIView *)autolayoutView;
- (void)enableAutolayout;

+ (UINib *)nib;

- (void)addTopAndBottomLineWithDefaultSetting;
- (void)addTopAndBottomWithHeight:(CGFloat)height color:(UIColor *)color;
- (void)addTopLineWithHeight:(CGFloat)height color:(UIColor *)color;
- (void)addBottomLineWithHeight:(CGFloat)height color:(UIColor *)color;
- (void)addLeftLineWithWidth:(CGFloat)width color:(UIColor *)color;
- (void)addRightLineWithWidth:(CGFloat)width color:(UIColor *)color;

@end
