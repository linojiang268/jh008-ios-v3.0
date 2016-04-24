//
//  GNActivityAlbumUploadVC.m
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityAlbumUploadVC.h"
#import "GNActivityAlbumUploadVM.h"
#import "GNActivityAlbumCVC.h"
#import "GNGalleryController.h"
#import <CTAssetsPickerController.h>


@interface GNActivityAlbumUploadVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) GNActivityAlbumUploadVM *viewModel;

@property (nonatomic, assign) BOOL isFirstShow;

@property (nonatomic, copy) void(^block)(void);

@end

@implementation GNActivityAlbumUploadVC

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"分享我的照片"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(startUpload:)];
    
}

- (void)uploadComplete:(void(^)(void))block {
    self.block = block;
}

- (instancetype)initWithActivityId:(NSUInteger)activityId {
    self = [super init];
    if (self) {
        self.viewModel = [[GNActivityAlbumUploadVM alloc] initWithActivityId:activityId];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isFirstShow) {
        [self showChooseView];
        [self setIsFirstShow:NO];
    }
}

- (void)binding {
    
    self.isFirstShow = YES;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kUIScreenWidth-8*4)/3, (kUIScreenWidth-8*4)/3);
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[GNActivityAlbumCVC nib] forCellWithReuseIdentifier:kUICellIdentifier];
}

- (void)startUpload:(UIBarButtonItem *)item {
    
    if (self.viewModel.photosArray.count <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请先添加照片"];
    }else {
        [SVProgressHUD showWithStatus:@"正在上传..." maskType:SVProgressHUDMaskTypeBlack];
        __weakify;
        [self.viewModel.uploadResponse start:YES success:^(id response, id model) {
            __strongify;
            [self.collectionView reloadData];
            [SVProgressHUD dismiss];
            if (self.viewModel.isEnd) {
                NSUInteger failedNumber = self.viewModel.photosArray.count;
                if (failedNumber > 0) {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld张照片上传失败",(long)failedNumber]];
                }else {
                    if (self.block) {
                        self.block();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } error:^(id response, NSInteger code) {
            
        } failure:^(id req, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"上传失败，请重试"];
        }];
    }
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.viewModel.photosArray.count < 9) {
        return self.viewModel.photosArray.count + 1;
    }
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNActivityAlbumCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUICellIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.viewModel.photosArray.count) {
        cell.imageView.image = [self.viewModel.photosArray objectAtIndex:indexPath.item];
        [cell showAdd:NO];
    }else {
        cell.imageView.image = nil;
        [cell showAdd:YES];
    }

    return cell;
}

#pragma mark -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewModel.photosArray.count == indexPath.item) {
        [self showChooseView];
    }else {
        [self showBrowserViewOrDeleteWithIndex:indexPath.item];
    }
}

#pragma mark -

- (void)showBrowserViewOrDeleteWithIndex:(NSUInteger)index {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看图片",@"删除图片", nil];
    
    __weakify;
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(id x) {
        __strongify;
        switch ([x intValue]) {
            case 0:
            {
                NSMutableArray *album = [NSMutableArray array];
                for (UIImage *image in self.viewModel.photosArray) {
                    MHGalleryItem *item = [MHGalleryItem itemWithImage:image];
                    [album addObject:item];
                }
                GNGalleryController *controller = [GNGalleryController galleryControllerWithAlbum:album defaultIndex:index];
                [self presentMHGalleryController:controller];
            }
                break;
            case 1:
            {
                [self.viewModel.photosArray removeObjectAtIndex:index];
                [self.collectionView reloadData];
            }
                break;
            default:
                break;
        }
    }];
    [actionSheet showInView:self.view];
}

- (void)showChooseView {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    
    __weakify;
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(id x) {
        __strongify;
        switch ([x intValue]) {
            case 0:
                [self presentControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                [self presentControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            default:
                break;
        }
    }];
    [actionSheet showInView:self.view];
}

- (void)presentControllerWithSourceType:(UIImagePickerControllerSourceType)type {

    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
    
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
        if (![UIImagePickerController isSourceTypeAvailable:type]) {
            [SVProgressHUD showErrorWithStatus:@"当前设备不支持拍照功能"];
        }else {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            controller.allowsEditing = YES;
            controller.sourceType = type;
            
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info count] > 0) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image) {
            [self.viewModel.photosArray addObject:image];
            [self.collectionView reloadData];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

#pragma mark - CTAssetsPickerControllerDelegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset {
    return picker.selectedAssets.count <= (8 - self.viewModel.photosArray.count);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (ALAsset *asset in assets) {
        [self.viewModel.photosArray addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
    }
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}










@end
