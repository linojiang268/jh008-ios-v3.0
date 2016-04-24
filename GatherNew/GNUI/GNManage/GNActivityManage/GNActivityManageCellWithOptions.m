//
//  GNActivityManageCellWithOptions.m
//  GatherNew
//
//  Created by yuanjun on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManageCellWithOptions.h"

@interface GNActivityManageCellWithOptions()

@property (weak, nonatomic) IBOutlet UILabel *activityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityMessageImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityMessageLabel;


@property (assign, nonatomic) NSInteger activityId;
@property (assign, nonatomic) BOOL enableMessage;

@end


@implementation GNActivityManageCellWithOptions

- (void)setActivityId:(NSInteger) activityId name:(NSString*)name time:(NSString*)time state:(NSInteger)state enableMessage:(BOOL)enableMessage{
    self.activityId = activityId;
    self.activityNameLabel.text = name;
    self.activityTimeLabel.text = time;
    self.enableMessage = enableMessage;
    if(self.enableMessage){
        [self.activityMessageImageView setImage:[UIImage imageNamed:@"manage_message"]];
        self.activityMessageLabel.textColor = kUIColorWithHexUint(GNUIColorWhite);
    }else{
        [self.activityMessageImageView setImage:[UIImage imageNamed:@"manage_message_disable"]];
        self.activityMessageLabel.textColor = kUIColorWithHexUint(GNUIColorDisabled);
    }
    
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
    self.activityEnrollView.userInteractionEnabled  = YES;
    self.activityCheckInView.userInteractionEnabled = YES;
    self.activityMessageView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

@end
