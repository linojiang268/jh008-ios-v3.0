//
//  UIView+XBHintViewExtension.h
//  XBHintViewExtension
//
//  Created by XIAOBAI on 15/4/20.
//  Copyright (c) 2015年 XBHintViewExtension. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  提示语视图类型
 */
typedef NS_ENUM(NSUInteger, XBHintViewType){
    /**
     *  无网络
     */
    XBHintViewTypeNetworkError   = 1,
    /**
     *  加载错误
     */
    XBHintViewTypeLoadError      = 2,
    /**
     *  无数据
     */
    XBHintViewTypeNoData         = 3,
    /**
     *  正在加载
     */
    XBHintViewTypeLoading        = 4,
};

@interface UIView (XBHintViewExtension)

- (void)showHintViewWithType:(XBHintViewType)HintType tapHandler:(void(^)(UIView *tapView))tapHandler;
- (void)showHintViewWithType:(XBHintViewType)HintType message:(NSString*)message tapHandler:(void(^)(UIView *tapView))tapHandler;
- (void)showHintViewWithType:(XBHintViewType)HintType message:(NSString*)message position:(CGPoint)point tapHandler:(void(^)(UIView *tapView))tapHandler;

- (void)showHintViewWithType:(XBHintViewType)HintType position:(CGPoint)point tapHandler:(void(^)(UIView *tapView))tapHandler;

- (void)showHintViewWithImage:(UIImage *)image text:(NSString *)text position:(CGPoint)point tapHandler:(void(^)(UIView *tapView))tapHandler;

- (void)showCustomView:(UIView *)customView tapHandler:(void(^)(UIView *tapView))tapHandler;

- (void)hideHintView;

@end
