//
//  GNGalleryController.m
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNGalleryController.h"
#import "GNGalleryImageViewerViewController.h"

@implementation GNGalleryController

- (void)addPhotos:(NSArray *)photos defaultIndex:(NSUInteger)index {
    
    NSMutableArray *album = [NSMutableArray arrayWithArray:self.galleryItems];
    [album addObjectsFromArray:photos];
    [self setGalleryItems:album];
    
    MHGalleryItem *item = [self itemForIndex:index];
    MHImageViewController *imageViewController =[MHImageViewController imageViewControllerForMHMediaItem:item
                                                                                          viewController:self.imageViewerViewController];
    imageViewController.pageIndex = index;
    self.presentationIndex = index;
    self.imageViewerViewController.pageIndex = index;
    
    [self.imageViewerViewController.pageViewController setViewControllers:@[imageViewController] direction:0 animated:NO completion:NULL];
//    [self.imageViewerViewController performSelector:@selector(updateTitleForIndex:) withObject:@(self.presentationIndex)];
}

- (instancetype)initWithAlbum:(NSArray *)album defaultIndex:(NSUInteger)index {
    self = [super init];
    if (!self)
        return nil;
    
    self.autoplayVideos = NO;
    
    self.navigationBarHidden = YES;

    self.preferredStatusBarStyleMH = UIStatusBarStyleLightContent;
    self.presentationStyle = MHGalleryViewModeImageViewerNavigationBarHidden;
    self.transitionCustomization = MHTransitionCustomization.new;
    self.transitionCustomization.interactiveDismiss = NO;
    self.transitionCustomization.dismissWithScrollGestureOnFirstAndLastImage = NO;
    self.UICustomization = MHUICustomization.new;
    self.UICustomization.showMHShareViewInsteadOfActivityViewController = NO;
    self.imageViewerViewController = GNGalleryImageViewerViewController.new;
    
    self.galleryItems = album;
    self.presentationIndex = index;
    self.viewControllers = @[self.imageViewerViewController];
    
    __weakify;
    [self finishedCallback:^(NSInteger currentIndex, UIImage *image, MHTransitionDismissMHGallery *interactiveTransition, MHGalleryViewMode viewMode) {
        __strongify;
        [self dismissViewControllerAnimated:YES dismissImageView:nil completion:NULL];
    }];

    return self;
}

+ (instancetype)galleryControllerWithAlbum:(NSArray *)album defaultIndex:(NSUInteger)index {
    return [[GNGalleryController alloc] initWithAlbum:album defaultIndex:index];
}

- (void)finishedCallback:(void(^)(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode))finishedCallback {
    self.finishedCallback = finishedCallback;
}

@end

@implementation UIViewController (GNGalleryViewController)

-(void)presentMHGalleryController:(MHGalleryController *)galleryController
{
    
    if(galleryController.UICustomization.useCustomBackButtonImageOnImageViewer){
        UIBarButtonItem *backBarButton = [UIBarButtonItem.alloc initWithImage:MHTemplateImage(@"ic_square")
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:nil];
        galleryController.overViewViewController.navigationItem.backBarButtonItem = backBarButton;
        galleryController.navigationBar.tintColor = galleryController.UICustomization.barButtonsTintColor;
    }
    
    galleryController.transitioningDelegate = self;
    galleryController.modalPresentationStyle = UIModalPresentationFullScreen;
    galleryController.navigationBar.barStyle = galleryController.UICustomization.barStyle;
    galleryController.navigationBar.barTintColor = galleryController.UICustomization.barTintColor;
    
    if (!galleryController.dataSource) {
        galleryController.dataSource = galleryController;
    }
    if (galleryController.presentationStyle == MHGalleryViewModeImageViewerNavigationBarHidden) {
        galleryController.imageViewerViewController.hiddingToolBarAndNavigationBar = YES;
    }
    [self presentViewController:galleryController animated:YES completion:NULL];
}

@end
