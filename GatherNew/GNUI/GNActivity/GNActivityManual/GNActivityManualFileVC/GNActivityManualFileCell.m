//
//  GNActivityManualFileCell.m
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualFileCell.h"
#import "GNActivityManualFileModel.h"

@interface GNActivityManualFileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation GNActivityManualFileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindingModel:(id)model {
    [super bindingModel:model];
    
    GNActivityManualFileItemModel *file = model;
    
    if ([file.extension isEqualToString:@"doc"] || [file.extension isEqualToString:@"docx"]) {
        self.avatarImage.image = [UIImage imageNamed:@"file_type_word"];
    }else if ([file.extension isEqualToString:@"xls"] || [file.extension isEqualToString:@"xlsx"]) {
        self.avatarImage.image = [UIImage imageNamed:@"file_type_excel"];
    }else if ([file.extension isEqualToString:@"pdf"]) {
        self.avatarImage.image = [UIImage imageNamed:@"file_type_pdf"];
    }else if ([file.extension isEqualToString:@"ppt"] || [file.extension isEqualToString:@"pptx"]) {
        self.avatarImage.image = [UIImage imageNamed:@"file_type_ppt"];
    }else if ([file.extension isEqualToString:@"jpg"]  ||
              [file.extension isEqualToString:@"jpeg"] ||
              [file.extension isEqualToString:@"png"]  ||
              [file.extension isEqualToString:@"bmp"]  ||
              [file.extension isEqualToString:@"gif"])
    {
        self.avatarImage.image = [UIImage imageNamed:@"file_type_jpg"];
    }else {
        self.avatarImage.image = [UIImage imageNamed:@"file_type_other"];
    }
    
    self.titleLabel.text = file.name;
    self.sizeLabel.text = [NSString stringWithFormat:@"%dkb",file.size / 1024];
}

@end
