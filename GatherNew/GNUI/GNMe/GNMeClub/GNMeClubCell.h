//
//  GNMeClubCell.h
//  GatherNew
//
//  Created by wudanfeng on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTVCBase.h"

@interface GNMeClubCell : GNTVCBase
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbActivityCount;
@property (weak, nonatomic) IBOutlet UIImageView *imageIsMyClub;

@property (assign, nonatomic) NSInteger clubId;

-(void)setUIData:(NSString *)url title:(NSString *)title count:(NSString *)count isShow:(BOOL)isShow;
@end
