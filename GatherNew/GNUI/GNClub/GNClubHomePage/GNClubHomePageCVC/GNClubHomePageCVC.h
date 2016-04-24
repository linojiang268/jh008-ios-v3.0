//
//  GNClubHomePageCVC.h
//  GatherNew
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNCVCBase.h"

@interface GNClubHomePageCVC : GNCVCBase

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setIsUpdated:(BOOL)updated;

@end
