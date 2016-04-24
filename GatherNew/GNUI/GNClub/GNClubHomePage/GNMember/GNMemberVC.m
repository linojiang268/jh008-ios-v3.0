//
//  GNMemberVC.m
//  GatherNew
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMemberVC.h"
#import "GNMemberCVC.h"
#import "GNVisitingCardVC.h"
#import "UIScrollView+XBRefreshExtension.h"

@interface GNMemberVC ()<UICollectionViewDataSource, UICollectionViewDelegate,XBTableViewRefreshDelegate>

@property (nonatomic, strong) GNMemberVM *viewModel;

@end

@implementation GNMemberVC

- (instancetype)initWithType:(GNMemberType)type
                      typeId:(NSUInteger)typeId {
    self = [super init];
    if (self) {
        self.title = type == GNMemberTypeClub ? @"社团成员": @"活动成员";
        self.viewModel = [[GNMemberVM alloc] initWithType:type typeId:typeId];
    }
    return self;
}

- (void)binding {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kUIScreenWidth-15*4)/3, (kUIScreenWidth-15*4)/3);
    layout.minimumInteritemSpacing = 7.5;
    layout.minimumLineSpacing = 7.5;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[GNMemberCVC nib] forCellWithReuseIdentifier:kUICellIdentifier];
    [self.collectionView addRefreshAndLoadMore];
    
    RAC(self.viewModel,page) = RACObserve(self.collectionView, page);
    
    __weakify;
    
    void(^errorHandler)(void) = ^{
        __strongify;
        if (self.viewModel.memberArray.count) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }else {
            [self.collectionView showHintViewWithType:XBHintViewTypeLoadError tapHandler:^(UIView *tapView) {
                __strongify;
                [self.collectionView hideHintView];
                [self.collectionView refresh];
            }];
        }
        [self.collectionView endAllRefresh];
    };
    [self.viewModel.refreshResponse start:NO success:^(id response, GNMemberListModel *model) {
        __strongify;
        
        if (!self.viewModel.memberArray.count) {
            [self.collectionView showHintViewWithType:XBHintViewTypeNoData tapHandler:^(UIView *tapView) {
                __strongify;
                [self.collectionView hideHintView];
                [self.collectionView refresh];
            }];
        }else {
            [self.collectionView reloadData];
            [self.collectionView hideHintView];
            [self.collectionView setTotalPage:model.pages];
        }
        [self.collectionView endAllRefresh];
    } error:^(id response, NSInteger code) {
        errorHandler();
    } failure:^(id req, NSError *error) {
        errorHandler();
    }];
    
    [self.collectionView refresh];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.memberArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNMemberCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUICellIdentifier forIndexPath:indexPath];
    GNMemberModel *model = [self.viewModel.memberArray objectAtIndex:indexPath.item];
    [cell bindingModel:model];
    
    return cell;
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GNMemberModel *model = [self.viewModel.memberArray objectAtIndex:indexPath.item];
    GNVisitingCardVC *controller = [GNVisitingCardVC loadFromGNUI:[GNUI meUI]];
    controller.viewModel = [[GNVisitingCardVM alloc] initWithUserId:model.id gender:model.gender];
    
    [self.navigationController pushVC:controller animated:YES];
}



@end
