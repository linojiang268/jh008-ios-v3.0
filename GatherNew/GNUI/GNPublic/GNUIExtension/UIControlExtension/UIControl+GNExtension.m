//
//  UIControl+GNExtension.m
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "UIControl+GNExtension.h"
#import <objc/runtime.h>

@implementation UIControl (GNExtension)

static char UIControlStateNormalColorKey;
static char UIControlStateHighlightedColorKey;
static char UIControlStateSelectedColorKey;
static char UIControlStateDisabledColorKey;

- (UIColor *)backgroundColorForState:(UIControlState)state {
    if (state == UIControlStateNormal) {
       return objc_getAssociatedObject(self, &UIControlStateNormalColorKey);
    }else if(state == UIControlStateHighlighted) {
       return objc_getAssociatedObject(self, &UIControlStateHighlightedColorKey);
    }else if(state == UIControlStateSelected) {
        return objc_getAssociatedObject(self, &UIControlStateSelectedColorKey);
    }else if(state == UIControlStateDisabled) {
        return objc_getAssociatedObject(self, &UIControlStateDisabledColorKey);
    }
    return nil;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    if (state == UIControlStateNormal) {
        objc_setAssociatedObject(self, &UIControlStateNormalColorKey, backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setBackgroundColor:backgroundColor];
    }else if(state == UIControlStateHighlighted) {
        objc_setAssociatedObject(self, &UIControlStateHighlightedColorKey, backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        @weakify(self);
        [RACObserve(self, highlighted) subscribeNext:^(id x) {
            @strongify(self);
            if ([x boolValue]) {
                [self setBackgroundColor:[self backgroundColorForState:UIControlStateHighlighted]];
            }else {
                [self setBackgroundColor:[self backgroundColorForState:UIControlStateNormal]];
            }
        }];
    }else if(state == UIControlStateSelected) {
        objc_setAssociatedObject(self, &UIControlStateSelectedColorKey, backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        @weakify(self);
        [RACObserve(self, selected) subscribeNext:^(id x) {
            @strongify(self);
            if ([x boolValue]) {
                [self setBackgroundColor:[self backgroundColorForState:UIControlStateSelected]];
            }else {
                [self setBackgroundColor:[self backgroundColorForState:UIControlStateNormal]];
            }
        }];
    }else if (state == UIControlStateDisabled) {
        objc_setAssociatedObject(self, &UIControlStateDisabledColorKey, backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        @weakify(self);
        [RACObserve(self, enabled) subscribeNext:^(id x) {
            @strongify(self);
            if (![x boolValue]) {
                [self setBackgroundColor:[self backgroundColorForState:UIControlStateDisabled]];
            }else {
                [self setBackgroundColor:[self backgroundColorForState:UIControlStateNormal]];
            }
        }];
    }
}

@end
