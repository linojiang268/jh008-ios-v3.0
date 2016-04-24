//
//  GNInterestTagCell.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNInterestTagCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageInteresetTag;
@property (weak, nonatomic) IBOutlet UIImageView *imageIsSelected;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

-(void)isSelected:(BOOL)flag selectedId:(NSInteger)sId;

@end
