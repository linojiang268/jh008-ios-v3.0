//
//  GNMeHeaderCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/30.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeHeaderCell.h"

@implementation GNMeHeaderCell

- (void)awakeFromNib {
    kUIAvatar(self.imageHeader, [UIColor clearColor]);
    
    self.lbName.textColor = kUIColorWithHexUint(GNUIColorBlack);
}

@end
