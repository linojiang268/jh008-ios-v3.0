//
//  GNClubActiveAlbumTVC.m
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubActiveAlbumTVC.h"
#import "GNClubAlbumModel.h"
#import "NSString+GNExtension.h"

@interface GNClubActiveAlbumTVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GNClubActiveAlbumTVC

- (void)awakeFromNib {
    self.titleLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.dateLabel.textColor = kUIColorWithHexUint(GNUIColorDarkgray);
}

- (void)bindingModel:(GNClubAlbumListItemModel *)model {
    [super bindingModel:model];
    
    self.titleLabel.text = model.title;
    self.dateLabel.text = [model.end_time substringYearMonthDay];
}

@end
