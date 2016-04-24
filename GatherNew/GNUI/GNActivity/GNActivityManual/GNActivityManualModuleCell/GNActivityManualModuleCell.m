//
//  GNActivityManualModuleCell.m
//  GatherNew
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualModuleCell.h"
#import "GNActivityDetailsModel.h"

@interface GNActivityManualModuleCell ()

@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;

@end

@implementation GNActivityManualModuleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindingModel:(id)model {
    [super bindingModel:model];
    
    GNActivityDetailsModel *manual = model;
    
    self.memberLabel.text = [NSString stringWithFormat:@"成员(%d)",manual.activity.activity_members_count];
    self.albumLabel.text = [NSString stringWithFormat:@"相册(%d)",manual.activity.activity_album_count];
    self.fileLabel.text = [NSString stringWithFormat:@"文件(%d)",manual.activity.activity_file_count];
}

@end
