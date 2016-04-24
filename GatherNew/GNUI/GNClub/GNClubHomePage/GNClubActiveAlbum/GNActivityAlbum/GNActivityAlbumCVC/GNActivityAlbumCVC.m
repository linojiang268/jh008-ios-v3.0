//
//  GNActivityAlbumCVC.m
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityAlbumCVC.h"
#import "GNActivityAlbumModel.h"

@interface GNActivityAlbumCVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewAdd;

@end

@implementation GNActivityAlbumCVC

- (void)awakeFromNib {

//    self.imageView.layer.borderWidth = 3.0;
//    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.deleteButton.hidden = YES;
}

- (void)bindingModel:(GNPhotoModel *)model {
    [self showAdd:NO];
    [self.imageView setImageWithURLString:model.image_url];
}

- (void)showAdd:(BOOL)show {
    self.imageViewAdd.hidden = !show;
}

@end
