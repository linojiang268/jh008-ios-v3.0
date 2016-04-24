//
//  GNClubNoticeTVC.m
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubNoticeTVC.h"

@interface GNClubNoticeTVC ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GNClubNoticeTVC

- (void)awakeFromNib {
    self.contentLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.dateLabel.textColor = kUIColorWithHexUint(GNUIColorDarkgray);
}

@end
