//
//  GNVideoPhotoBrowserVC.m
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNGalleryImageViewerViewController.h"
#import "UIView+GNExtension.h"
#import <Masonry.h>
#import <objc/objc.h>
#import <objc/runtime.h>

@interface GNGalleryImageViewerViewController ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation GNGalleryImageViewerViewController

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView autolayoutView];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont boldSystemFontOfSize:12];
        
        [_numberLabel enableAutolayout];
    }
    return _numberLabel;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_shareButton enableAutolayout];
        [_shareButton setImage:[UIImage imageNamed:@"album_download"] forState:UIControlStateNormal];
        [_shareButton setTintColor:[UIColor whiteColor]];
        [_shareButton addTarget:self action:@selector(sharePressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTitleForIndex:self.pageIndex];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MHStatusBar() setAlpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.toolbar.hidden = YES;
    
    UIView *superView = self.view;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.bottom.equalTo(superView.mas_bottom);
        make.leading.equalTo(superView.mas_leading);
        make.trailing.equalTo(superView.mas_trailing);
    }];

    superView = self.bottomView;
    
    /*[self.bottomView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(superView);
        make.top.equalTo(superView);
        make.leading.equalTo(superView).with.offset(50);
        make.trailing.equalTo(superView).with.offset(-50);
    }];*/
    
    [self.bottomView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
        make.width.equalTo(@50);
        make.height.equalTo(superView);
        make.trailing.equalTo(superView);
    }];
}

-(void)sharePressed{
    UIActivityViewController *act = [UIActivityViewController.alloc initWithActivityItems:@[[(MHImageViewController*)self.pageViewController.viewControllers.firstObject imageView].image] applicationActivities:nil];
    [self presentViewController:act animated:YES completion:nil];
}


- (void)updateTitleForIndex:(NSInteger)pageIndex {
    /*if (self.galleryItems.count > 0) {
        self.numberLabel.text = [NSString stringWithFormat:@"%d / %d",(int)self.pageIndex+1,(int)self.galleryItems.count];
    }else {
        self.numberLabel.hidden = YES;
    }
    
    MHImageViewController *controller = [self.pageViewController.viewControllers firstObject];
    controller.scrollView.showsHorizontalScrollIndicator = NO;
    controller.scrollView.showsVerticalScrollIndicator = NO;*/
}

@end

@implementation MHImageViewController (GNReplaceTapEvent)

+ (void)initialize {
    Method tapEvent = class_getInstanceMethod([self class], NSSelectorFromString(@"handelImageTap:"));
    Method closeEvent = class_getInstanceMethod([self class], @selector(close:));
    method_exchangeImplementations(tapEvent, closeEvent);
}

- (void)close:(UIGestureRecognizer *)gestureRecognizer {
    [(GNGalleryImageViewerViewController *)self.viewController donePressed];
}















@end
