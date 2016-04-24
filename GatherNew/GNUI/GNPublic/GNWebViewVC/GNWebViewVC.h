//
//  GNWebViewVC.h
//  GatherNew
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"
#import "EasyJSWebView.h"

@interface GNWebViewVC : GNVCBase

@property (nonatomic, strong) EasyJSWebView *webView;

- (instancetype)initWithTitle:(NSString *)title
                          url:(NSURL *)url;

/// 增加分享
- (void)addShareWithClickBlock:(void(^)(void))block;

@end
