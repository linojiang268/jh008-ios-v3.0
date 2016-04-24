//
//  GNCollectionViewH.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNCollectionViewH.h"
#import "GNCollectionViewHCell.h"
#import "UIView+GNExtension.h"

@implementation GNCollectionViewH

-(id)initView:(NSMutableArray *)mutArray rect:(CGRect)rect{
    self = [super init];
    if (self) {
        self.frame = rect;
        self.mutArray = mutArray;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(55, self.bounds.size.height-5)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置其边界
    //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self.collectionView registerNib:[GNCollectionViewHCell nib] forCellWithReuseIdentifier:@"GNCollectionViewHCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mutArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GNCollectionViewHCell";
    GNCollectionViewHCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    cell.iamgeHeader.backgroundColor = [UIColor blackColor];
//    [cell.iamgeHeader setImage:[UIImage imageNamed:@""]];
    cell.lbName.text = @"123";

    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中");
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
