//
//  GNGNGNActivitySponsorCell.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseCell.h"

@interface GNActivitySponsorCell : GNActivityBaseCell
@property (weak, nonatomic) IBOutlet UILabel *lbCellType;
@property (weak, nonatomic) IBOutlet UIView *view_line;
@property (weak, nonatomic) IBOutlet UIImageView *imageMain;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) NSString *phoneNumber;

- (IBAction)btnCallAction:(id)sender;
@end
