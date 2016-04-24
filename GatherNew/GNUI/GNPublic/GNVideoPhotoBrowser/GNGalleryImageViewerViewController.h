//
//  GNVideoPhotoBrowserVC.h
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <MHGalleryImageViewerViewController.h>

@protocol GNGalleryImageViewerViewControllerDelegate <NSObject>

@optional
- (void)donePressed;

@end

@interface GNGalleryImageViewerViewController : MHGalleryImageViewerViewController<GNGalleryImageViewerViewControllerDelegate>

- (void)updateTitleForIndex:(NSInteger)pageIndex;

@end

@interface MHImageViewController (GNReplaceTapEvent)

@end