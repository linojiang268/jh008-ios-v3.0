//
//  GNMemberCVC.m
//  GatherNew
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMemberCVC.h"
#import "GNMemberModel.h"

@implementation GNMemberCVC

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)bindingModel:(GNMemberModel *)model {
    [super bindingModel:model];
    
    [self.imageView setUserAvatarImageWithURLString:model.avatar];
    
    UIColor *color = [GNApp colorWithGender:model.gender];
    
    kUIRoundCorner(self.imageView, color, 3, (kUIScreenWidth-15*4)/3/2);
}

@end
