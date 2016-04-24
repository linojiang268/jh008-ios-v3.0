//
//  GNActivityAlbumVC.m
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityAlbumVC.h"
#import "GNActivityAlbumCVC.h"
#import "GNGalleryController.h"
#import "GNMyShareAlbumCVC.h"
#import "GNMyShareAlbumVC.h"

@interface GNActivityAlbumVC ()<UICollectionViewDataSource, UICollectionViewDelegate, MHGalleryDelegate>

@property (nonatomic, strong) GNActivityAlbumVM *viewModel;

@property (nonatomic, strong) GNGalleryController *galleryController;

@property (nonatomic, strong) NSMutableArray *albumsArray;

@end

@implementation GNActivityAlbumVC

- (instancetype)initWithType:(GNActivityAlbumType)type
                  activityId:(NSUInteger)activityId
{
    self = [super init];
    if (self) {
        self.viewModel = [[GNActivityAlbumVM alloc] initWithType:type activityId:activityId];
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
    [self.collectionView registerNib:[GNMyShareAlbumCVC nib] forCellWithReuseIdentifier:@"myShare"];
    
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
}

- (void)prepareRefresh {
    self.isFirstRefresh = YES;
}

- (NSUInteger)itemCount {
    NSUInteger count = self.viewModel.albumArray.count;
    if (self.viewModel.type == GNActivityAlbumTypeSponsor) {
        return count;
    }else if (count > 0) {
        return (count + 1);
    }
    return 0;
}

- (NSUInteger)indexAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.type == GNActivityAlbumTypeSponsor) {
        return indexPath.item;
    }
    return (indexPath.item - 1);
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self itemCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewModel.type == GNActivityAlbumTypeUser) {
        if (indexPath.item == 0) {
            return [collectionView dequeueReusableCellWithReuseIdentifier:@"myShare" forIndexPath:indexPath];
        }
    }
    
    GNActivityAlbumCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUICellIdentifier forIndexPath:indexPath];
    [cell bindingModel:[self.viewModel.albumArray objectAtIndex:[self indexAtIndexPath:indexPath]]];
    
    return cell;
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
    
    if (self.viewModel.type == GNActivityAlbumTypeUser && indexPath.item == 0) {
        GNMyShareAlbumVC *controller = [[GNMyShareAlbumVC alloc] initWithActivityId:self.viewModel.activityId];
        [self.navigationController pushVC:controller animated:YES];
    }else {
        self.galleryController = [GNGalleryController galleryControllerWithAlbum:self.albumsArray defaultIndex:[self indexAtIndexPath:indexPath]];
        self.galleryController.galleryDelegate = self;
        [self presentMHGalleryController:self.galleryController];
        [self galleryController:self.galleryController didShowIndex:[self indexAtIndexPath:indexPath]];
    }
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
