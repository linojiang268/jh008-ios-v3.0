//
//  GNCollectionVCBase.m
//  GatherNew
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNCollectionVCBase.h"
#import <Masonry.h>

@interface GNCollectionVCBase ()

@property (nonatomic,strong) UICollectionViewLayout *collectionViewLayout;

@end

@implementation GNCollectionVCBase

- (UICollectionViewLayout *)collectionViewLayout {
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _collectionViewLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat topPadding = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat bottomPadding = self.hidesBottomBarWhenPushed ? 0 : 49;
        CGRect r = [[UIScreen mainScreen] bounds];
        r.size.height -= (topPadding + bottomPadding);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    }
    return _collectionView;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super init];
    if (self) {
        self.collectionViewLayout = layout;
    }
    return self;
}

- (void)setupUI {
    [super setupUI];
    [self.view addSubview:self.collectionView];
    [self.collectionView setBackgroundColor:kUIColorWithHexUint(GNUIColorGrayWhite)];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstRefresh = YES;
}

@end
