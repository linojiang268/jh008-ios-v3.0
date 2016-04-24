//
//  UIView+XBHintViewExtension.m
//  XBHintViewExtension
//
//  Created by XIAOBAI on 15/4/20.
//  Copyright (c) 2015年 XBHintViewExtension. All rights reserved.
//

#import "UIView+XBHintViewExtension.h"
#import <objc/runtime.h>

@implementation UIView (XBHintViewExtension)

static char XBHintViewKey;
- (void)setHintView:(UIView *)HintView {
    if (HintView != [self HintView]) {
        objc_setAssociatedObject(self, &XBHintViewKey,HintView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [HintView setUserInteractionEnabled:YES];
        [HintView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    }
}

- (UIView *)HintView {
    return objc_getAssociatedObject(self, &XBHintViewKey);
}

static char XBTapHandlerKey;
- (void)setTapHandler:(void(^)(UIView *tapView))tapHandler {
    
    if (tapHandler != [self tapHandler]) {
        objc_setAssociatedObject(self, &XBTapHandlerKey,tapHandler,OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void (^)(UIView *tapView))tapHandler {
    return objc_getAssociatedObject(self, &XBTapHandlerKey);
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    if ([self tapHandler]) {
        [self tapHandler](gesture.view);
    }
}

- (void)showHintViewWithType:(XBHintViewType)HintType tapHandler:(void(^)(UIView *tapView))tapHandler {
    [self hideHintView];
    [self showHintViewWithType:HintType position:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) tapHandler:tapHandler];
}

- (void)showHintViewWithType:(XBHintViewType)HintType position:(CGPoint)point tapHandler:(void(^)(UIView *tapView))tapHandler {
    [self hideHintView];
    switch (HintType) {
        case XBHintViewTypeNetworkError:
            [self showHintViewWithImage:[UIImage imageNamed:@"load_no_network"] text:@"网络异常，请连接网络后点击屏幕重试！" position:point tapHandler:tapHandler];
            break;
        case XBHintViewTypeLoadError:
            [self showHintViewWithImage:[UIImage imageNamed:@"load_error"] text:@"加载失败，点击屏幕重试！" position:point  tapHandler:tapHandler];
            break;
        case XBHintViewTypeNoData:
            [self showHintViewWithImage:[UIImage imageNamed:@"load_no_data"] text:@"还没有东西噢，点击屏幕刷新或是先看看其他的吧！" position:point tapHandler:tapHandler];
            break;
        case XBHintViewTypeLoading:
            [self showHintViewWithImage:nil text:@"正在加载" position:point tapHandler:tapHandler];
        default:
            break;
    }
}


- (void)showHintViewWithType:(XBHintViewType)HintType message:(NSString*)message tapHandler:(void(^)(UIView *tapView))tapHandler {
    [self hideHintView];
    [self showHintViewWithType:HintType message:message position:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) tapHandler:tapHandler];
}



- (void)showHintViewWithType:(XBHintViewType)HintType message:(NSString*)message position:(CGPoint)point tapHandler:(void(^)(UIView *tapView))tapHandler {
    [self hideHintView];
    switch (HintType) {
        case XBHintViewTypeNetworkError:
            [self showHintViewWithImage:[UIImage imageNamed:@"load_no_network"] text:message position:point tapHandler:tapHandler];
            break;
        case XBHintViewTypeLoadError:
            [self showHintViewWithImage:[UIImage imageNamed:@"load_error"] text:message position:point  tapHandler:tapHandler];
            break;
        case XBHintViewTypeNoData:
            [self showHintViewWithImage:[UIImage imageNamed:@"load_no_data"] text:message position:point tapHandler:tapHandler];
            break;
        case XBHintViewTypeLoading:
            [self showHintViewWithImage:nil text:message position:point tapHandler:tapHandler];
        default:
            break;
    }
}



- (void)checkViewWithShow:(BOOL)show {
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)self setScrollEnabled:!show];
    }
}

- (void)showCustomView:(UIView *)customView tapHandler:(void(^)(UIView *tapView))tapHandler {
    [self checkViewWithShow:YES];
    [self hideHintView];
    [self setHintView:customView];
    [self setTapHandler:tapHandler];
    [self addSubview:customView];
}

- (void)hideHintView {
    if ([self HintView]) {
        [self checkViewWithShow:NO];
        [[self HintView] setHidden:YES];
        [[self HintView] removeFromSuperview];
    }
}

- (void)showHintViewWithImage:(UIImage *)image text:(NSString *)text position:(CGPoint)point tapHandler:(void(^)(UIView *tapView))tapHandler {
    [self checkViewWithShow:YES];
    [self setTapHandler:tapHandler];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    view.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.012];
    
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.center = view.center;
        [view addSubview:imageView];
    }else {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView startAnimating];
        indicatorView.center = view.center;
        [view addSubview:indicatorView];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = text;
    [label sizeToFit];
    
    CGRect rect = label.bounds;
    rect.origin.y = view.center.y + (image.size.height > 0 ? image.size.height : 20) / 2 + 10;
    rect.origin.x = view.center.x - label.bounds.size.width / 2;
    label.frame = rect;
    [view addSubview:label];
    
    [view setCenter: point];
    [self setHintView:view];
    [self addSubview:view];
}


@end
