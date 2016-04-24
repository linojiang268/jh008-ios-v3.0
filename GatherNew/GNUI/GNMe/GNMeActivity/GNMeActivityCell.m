//
//  GNMeActivityCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeActivityCell.h"
#import "GNActivityListModel.h"

@implementation GNMeActivityCell

-(void)bindingModel:(id)model{
    GNActivities *activityModel = model;
    
    self.lbActivityName.text = activityModel.title;
    self.lbPosition.text = activityModel.address;
    
    self.lbJoinPersonNumber.text = [NSString stringWithFormat:@"%ld人参加",(long)activityModel.enrolled_num];
    
    [self.lbActivityName setTextColor:kUIColorWithHexUint(GNUIColorBlack)];
    
    [self.lbJoinPersonNumber setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lbPosition setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    
    
    if (activityModel.sub_status == 5) {//已结束
        self.markLabel.text = @"已结束";
        self.markLabel.textColor = kUIColorWithHexUint(0xff666666);
        self.markLabel.layer.borderColor = kUIColorWithHexUint(0xff666666).CGColor;
    }else{
        if (activityModel.sub_status == 4 && activityModel.applicant_status == 3) {//进行中
            self.markLabel.text = @"报名成功";
            self.markLabel.textColor = kUIColorWithHexUint(GNUIColorBlue);
            self.markLabel.layer.borderColor = kUIColorWithHexUint(GNUIColorBlue).CGColor;
        }else{
            if (activityModel.applicant_status == 1) {//审核中
                self.markLabel.text = @"待审核";
                self.markLabel.textColor = kUIColorWithHexUint(GNUIColorOrange);
                self.markLabel.layer.borderColor = kUIColorWithHexUint(GNUIColorOrange).CGColor;
            }else if (activityModel.applicant_status == 2){//代缴费
                self.markLabel.text = @"未支付";;
                self.markLabel.textColor = kUIColorWithHexUint(GNUIColorOrange);
                self.markLabel.layer.borderColor = kUIColorWithHexUint(GNUIColorOrange).CGColor;
            }else{//待参加
                self.markLabel.text = @"报名成功";
                self.markLabel.textColor = kUIColorWithHexUint(GNUIColorBlue);
                self.markLabel.layer.borderColor = kUIColorWithHexUint(GNUIColorBlue).CGColor;
            }
        }
    }
    
    NSArray *arrayA = [activityModel.begin_time componentsSeparatedByString:@" "];
    NSString *timeActivity =arrayA[1];
    self.lbTime.text = [timeActivity substringWithRange:NSMakeRange(0, 5)];
}

@end
