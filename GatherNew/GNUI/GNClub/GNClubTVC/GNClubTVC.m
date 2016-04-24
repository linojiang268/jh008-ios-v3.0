//
//  GNClubTVC.m
//  GatherNew
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubTVC.h"
#import "GNClubListModel.h"

@interface GNClubTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *activeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@end

@implementation GNClubTVC

- (void)awakeFromNib {
    
    kUIRoundCorner(self.imageViewLogo, [UIColor clearColor], 0, 40);
    self.labelName.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.activeNumberLabel.textColor = kUIColorWithHexUint(GNUIColorDarkgray);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindingModel:(GNClubDetailModel *)model {
    [super bindingModel:model];
    
    [self.imageViewLogo setClubLogoImageWithURLString:model.logo_url];
    [self.labelName setText:model.name];
    [self.activeNumberLabel setText:[NSString stringWithFormat:@"新活动:%ld",(long)model.activity_num]];
    if (model.joined) {
        self.markLabel.text = @"已加入";
        self.markLabel.hidden = NO;
    }else if (model.requested) {
        self.markLabel.text = @"审核中";
        self.markLabel.hidden = NO;
    }else {
        self.markLabel.hidden = YES;
    }
}

@end
