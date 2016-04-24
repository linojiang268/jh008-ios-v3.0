//
//  GNActivityAlbumCVC.h
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNCVCBase.h"

@interface GNActivityAlbumCVC : GNCVCBase

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (void)showAdd:(BOOL)show;

@end
