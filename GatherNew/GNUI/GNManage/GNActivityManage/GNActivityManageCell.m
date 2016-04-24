//
//  GNActivityManageCell.m
//  GatherNew
//
//  Created by yuanjun on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManageCell.h"


@interface GNActivityManageCell()

@property (weak, nonatomic) IBOutlet UILabel *activityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;

@end

@implementation GNActivityManageCell



-(void)setActivityName:(NSString*)name time:(NSString*)time state:(NSInteger)state {
    self.activityNameLabel.text = name;
    self.activityTimeLabel.text = time;
    switch (state) {
        case 1:
            self.activityStateLabel.text = @"进行中";
            self.activityStateLabel.backgroundColor = kUIColorWithHexUint(GNUIColorOrange);
            break;
        case 2:
            self.activityStateLabel.text = @"报名中";
            self.activityStateLabel.backgroundColor = kUIColorWithHexUint(GNUIColorBlue);
            break;
        case 3:
            self.activityStateLabel.text = @"即将开始";
            self.activityStateLabel.backgroundColor = kUIColorWithHexUint(GNUIColorGreen);
            break;
        case 5:
            self.activityStateLabel.text = @"已结束";
            self.activityStateLabel.backgroundColor = kUIColorWithHexUint(GNUIColorDisabled);
            break;
        case 4:
        default:
            self.activityStateLabel.text = @"进行中";
            self.activityStateLabel.backgroundColor = kUIColorWithHexUint(GNUIColorOrange);
            break;
    }
}




- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

@end
