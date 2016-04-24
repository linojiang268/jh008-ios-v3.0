//
//  GNCollectionViewH.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNCollectionViewH : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *mutArray;


-(id)initView:(NSMutableArray *)mutArray rect:(CGRect)rect;

@end
