//
//  GNGalleryController.h
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "MHGalleryController.h"

@interface GNGalleryController : MHGalleryController

- (void)addPhotos:(NSArray *)photos defaultIndex:(NSUInteger)index;

+ (instancetype)galleryControllerWithAlbum:(NSArray *)album defaultIndex:(NSUInteger)index;

- (void)finishedCallback:(void(^)(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode))finishedCallback;

@end

@interface UIViewController (GNGalleryViewController)

-(void)presentMHGalleryController:(MHGalleryController *)galleryController;

@end
