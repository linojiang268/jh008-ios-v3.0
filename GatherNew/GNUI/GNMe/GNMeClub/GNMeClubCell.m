//
//  GNMeClubCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeClubCell.h"


@implementation GNMeClubCell

- (void)awakeFromNib {
    kUIAvatar(self.imageHeader, [UIColor clearColor]);
}

-(void)setUIData:(NSString *)url title:(NSString *)title count:(NSString *)count isShow:(BOOL)isShow{
    [self.imageHeader setUserAvatarImageWithURLString:url];
    self.lbTitle.text = title;
    self.lbActivityCount.text = count;
    //self.imageIsMyClub.hidden = isShow;
    
    [self.lbTitle setTextColor:kUIColorWithHexUint(GNUIColorBlack)];
    [self.lbActivityCount setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
}


@end
