//
//  GNClubNewsTVC.m
//  GatherNew
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubNewsTVC.h"
#import "GNClubNewsModel.h"

@interface GNClubNewsTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCover;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation GNClubNewsTVC

- (void)awakeFromNib {
    self.titleLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.dateLabel.textColor = kUIColorWithHexUint(GNUIColorDarkgray);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindingModel:(GNClubNewsModel *)model {
    [super bindingModel:model];
    
    [self.imageViewCover setImageWithURLString:model.cover_url];
    [self.titleLabel setText:model.title];
    [self.dateLabel setText:model.publish_time];
}

@end
