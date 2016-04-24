//
//  UIView+GNAutoLayoutExtension.m
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "UIView+GNExtension.h"

@implementation UIView (GNExtension)

+ (UIView *)autolayoutView {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (void)enableAutolayout {
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

#pragma mark -

- (void)addTopAndBottomLineWithDefaultSetting {
    [self addTopAndBottomWithHeight:0.5 color:kUIColorWithHexUint(GNUIColorGray)];
}

- (void)addTopAndBottomWithHeight:(CGFloat)height color:(UIColor *)color {
    [self addTopLineWithHeight:height color:color];
    [self addBottomLineWithHeight:height color:color];
}

- (void)addTopLineWithHeight:(CGFloat)height color:(UIColor *)color {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), height);
    layer.backgroundColor = [color CGColor];
    [self.layer addSublayer:layer];
}

- (void)addBottomLineWithHeight:(CGFloat)height color:(UIColor *)color {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-height, CGRectGetWidth(self.bounds), height);
    layer.backgroundColor = [color CGColor];
    [self.layer addSublayer:layer];
}

- (void)addLeftLineWithWidth:(CGFloat)width color:(UIColor *)color {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds));
    layer.backgroundColor = [color CGColor];
    [self.layer addSublayer:layer];
}

- (void)addRightLineWithWidth:(CGFloat)width color:(UIColor *)color {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(CGRectGetWidth(self.bounds)-width, 0, width, CGRectGetHeight(self.bounds));
    layer.backgroundColor = [color CGColor];
    [self.layer addSublayer:layer];
}

@end
