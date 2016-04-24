//
//  GNCollectionVCBase.h
//  GatherNew
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"
#import "UIScrollView+XBRefreshExtension.h"

@interface GNCollectionVCBase : GNVCBase

@property (nonatomic, strong) UICollectionView *collectionView;

// The only method of initialization
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout;

@property (nonatomic, assign) BOOL isFirstRefresh;

@end
