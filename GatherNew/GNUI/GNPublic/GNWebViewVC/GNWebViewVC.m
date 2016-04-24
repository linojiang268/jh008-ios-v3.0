//
//  GNWebViewVC.m
//  GatherNew
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNWebViewVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "GNShareFromWebJS.h"

@interface GNWebViewVC ()<NJKWebViewProgressDelegate, UIWebViewDelegate> {
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, copy) void(^block)(void);

@end

@implementation GNWebViewVC

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url {
    self = [super init];
    if (self) {
        self.title = title;
        self.url = url;
    }
    return self;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[EasyJSWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight-64)];
        
        GNShareFromWebJS* interface = [GNShareFromWebJS new];
        [_webView addJavascriptInterfaces:interface WithName:@"S"];
        
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] 																		 pathForResource:@"test" ofType:@"html"]isDirectory:NO]]];
    }
    return _webView;
}

- (void)setupUI {
    [super setupUI];
    [self.view addSubview:self.webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progress = 0.0;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)addShareWithClickBlock:(void (^)(void))block {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonPressed)];
    self.block = block;
}

- (void)shareButtonPressed {
    if (self.block) {
        self.block();
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    __weakify;
    [self.webView showHintViewWithType:XBHintViewTypeLoadError tapHandler:^(UIView *tapView) {
        __strongify;
        [self binding];
    }];
}

- (void)binding {
    [self.webView hideHintView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

@end
