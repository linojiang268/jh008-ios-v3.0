//
//  GNGNGNActivitySponsorCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivitySponsorCell.h"
#import "GNActivityDetailsModel.h"

@interface GNActivitySponsorCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;


@end

@implementation GNActivitySponsorCell

- (void)awakeFromNib {
    kUIAvatar(self.imageMain, [UIColor clearColor]);
    self.lineViewHeight.constant = 0.5;
    self.lbTitle.textColor = kUIColorWithHexUint(GNUIColorBlack);
}

-(void)bindingModel:(id)model{
    
    GNActivityDetailsModel *detailsModel = model;
    
    [self.lbCellType setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.view_line setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    self.lbTitle.text = detailsModel.activity.team.name;
    self.phoneNumber =detailsModel.activity.telephone;
    
    [self.imageMain setImageWithURLString:detailsModel.activity.team.logo_url];

    self.btnCall.hidden = (self.phoneNumber == nil || [self.phoneNumber length] == 0);
}



- (IBAction)btnCallAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(callPhone:)]) {
        [self.delegate callPhone:self.phoneNumber];
    }
}
@end
