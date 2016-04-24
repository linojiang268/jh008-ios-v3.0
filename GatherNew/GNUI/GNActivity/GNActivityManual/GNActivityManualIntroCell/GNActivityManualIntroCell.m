//
//  GNActivityManualIntroCell.m
//  GatherNew
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualIntroCell.h"

@implementation GNActivityManualIntroCell

- (void)awakeFromNib {
    
    kUIRoundCorner(self.button, [UIColor clearColor], 0, 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
