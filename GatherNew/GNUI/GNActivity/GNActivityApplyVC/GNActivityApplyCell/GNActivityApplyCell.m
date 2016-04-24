//
//  GNActivityApplyCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityApplyCell.h"
#import "GNCollectionViewH.h"

@implementation GNActivityApplyCell

-(void)bindingModel:(id)model{
        [self.lbTitle setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
        [self.view_line setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    
    
    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        mutArray[i] = @"club_demo_avatar";
    }
    
    GNCollectionViewH *collectionView = [[GNCollectionViewH alloc]initView:mutArray rect:CGRectMake(0, 30, self.bounds.size.width, self.bounds.size.height-30)];
    [self addSubview:collectionView];
    
}

@end
