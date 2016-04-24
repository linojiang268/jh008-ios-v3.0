//
//  GNMainClubCell.m
//  GatherNew
//
//  Created by apple on 15/9/18.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMainClubCell.h"

@implementation GNMainClubCell

- (void)awakeFromNib {
    self.collectionView.backgroundColor = [UIColor clearColor];
    CGFloat space = (kUIScreenWidth-(70 * 4)) / 5;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(70, 70);
    layout.minimumLineSpacing = space - 3;
    layout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
