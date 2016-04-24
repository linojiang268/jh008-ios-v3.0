//
//  GNMyShareAlbumVC.m
//  GatherNew
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMyShareAlbumVC.h"
#import "GNActivityAlbumCVC.h"
#import "GNGalleryController.h"
#import "GNActivityMyAlbumVM.h"

@interface GNMyShareAlbumVC ()<UICollectionViewDataSource, UICollectionViewDelegate, MHGalleryDelegate>

@property (nonatomic, strong) GNActivityMyAlbumVM *viewModel;

@property (nonatomic, strong) GNGalleryController *galleryController;

@property (nonatomic, strong) NSMutableArray *albumsArray;

@end

@implementation GNMyShareAlbumVC

- (instancetype)initWithActivityId:(NSUInteger)activityId
{
    self = [super init];
    if (self) {
        self.title = @"我的分享";
        self.viewModel = [[GNActivityMyAlbumVM alloc] initWithActivityId:activityId];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isFirstRefresh) {
        [self.collectionView refresh];
        [self setIsFirstRefresh:NO];
    }
}

- (void)binding {
    
    self.albumsArray = [[NSMutableArray alloc] init];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kUIScreenWidth-8*4)/3, (kUIScreenWidth-8*4)/3);
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView addRefreshAndLoadMore];
    [self.collectionView registerNib:[GNActivityAlbumCVC nib] forCellWithReuseIdentifier:kUICellIdentifier];
    
    RAC(self.viewModel,page) = RACObserve(self.collectionView, page);
    
    __weakify;
    void(^errorHandler)(void) = ^{
        __strongify;
        if (self.viewModel.albumArray.count) {
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
    [self.viewModel.refreshResponse start:NO success:^(id response, GNActivityAlbumListModel *model) {
        __strongify;
        
        if (!self.viewModel.albumArray.count) {
            [self.collectionView showHintViewWithType:XBHintViewTypeNoData tapHandler:^(UIView *tapView) {
                __strongify;
                [self.collectionView hideHintView];
                [self.collectionView refresh];
            }];
        }else {
            [self.collectionView reloadData];
            [self.collectionView hideHintView];
            [self.collectionView setTotalPage:model.pages];
            [self appendToBroser:model.images];
        }
        [self.collectionView endAllRefresh];
    } error:^(id response, NSInteger code) {
        errorHandler();
    } failure:^(id req, NSError *error) {
        errorHandler();
    }];
    
    [self.viewModel.deleteResponse start:NO success:^(id response, id model) {
        [SVProgressHUD dismiss];
        __strongify;
        [self.albumsArray removeObjectAtIndex:self.viewModel.deletePhotoIndex];
        [self.viewModel.albumArray removeObjectAtIndex:self.viewModel.deletePhotoIndex];
        [self.collectionView reloadData];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
    }];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.albumArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GNActivityAlbumCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUICellIdentifier forIndexPath:indexPath];
    [cell bindingModel:[self.viewModel.albumArray objectAtIndex:indexPath.item]];
    [cell.deleteButton setHidden:NO];
    [cell.deleteButton setTag:indexPath.item];
    [cell.deleteButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark -

- (void)deletePhoto:(UIButton *)button {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
        if ([x integerValue]) {
            [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeBlack];
            [self.viewModel deletePhotoWithIndex:button.tag];
        }
    }];
    [alert show];
}

#pragma mark -

- (void)appendToBroser:(NSArray *)photos {
    
    if (self.viewModel.page == kStartPage) {
        [self.albumsArray removeAllObjects];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (GNPhotoModel *model in photos) {
        MHGalleryItem *item = [MHGalleryItem itemWithURL:model.image_url galleryType:MHGalleryTypeImage];
        [self.albumsArray addObject:item];
        [tempArray addObject:item];
    }
    
    if (self.galleryController) {
        [self.galleryController addPhotos:tempArray defaultIndex:self.galleryController.imageViewerViewController.pageIndex];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.galleryController = [GNGalleryController galleryControllerWithAlbum:self.albumsArray defaultIndex:indexPath.item];
    self.galleryController.galleryDelegate = self;
    [self presentMHGalleryController:self.galleryController];
    [self galleryController:self.galleryController didShowIndex:indexPath.item];
}

#pragma mark -

-(void)galleryController:(MHGalleryController*)galleryController didShowIndex:(NSInteger)index {
    if (self.collectionView.page < self.collectionView.totalPage && !self.viewModel.loading) {
        if (index >= (self.albumsArray.count - 5)) {
            self.collectionView.page++;
        }
    }
}

@end
