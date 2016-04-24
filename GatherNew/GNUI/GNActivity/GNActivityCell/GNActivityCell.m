//
//  GNActivityCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityCell.h"
#import "GNActivityListModel.h"

@interface GNActivityCell()

@end
@implementation GNActivityCell

- (void)awakeFromNib {
    self.imageMain.layer.masksToBounds = YES;
    
    self.btnMyTeam.hidden = YES;
}

-(void)bindingModel:(id)model{

    self.model = model;
    
    GNActivities *activiety = model;
    
    [self.imageMain setImageWithURL:activiety.cover_url];
    [self.imageLocation setImage:[UIImage imageNamed:@"activity_location"]];
    
    switch (activiety.sub_status) {
        case GNActivityStatusCreateing:
        {
            self.lb_ActivityState.text = @"筹备中";
            [self.image_ActivityState setImage:[UIImage imageNamed:@"activity_joinning"]];
        }
            break;
        case GNActivityStatusApplying:
        {
            self.lb_ActivityState.text = @"报名中";
            [self.image_ActivityState setImage:[UIImage imageNamed:@"activity_joinning"]];
        }
            break;
        case GNActivityStatusInPrepare:
        {
            self.lb_ActivityState.text = @"即将开始";
            [self.image_ActivityState setImage:[UIImage imageNamed:@"activity_joinning"]];
        }
            break;
        case GNActivityStatusRunning:
        {
            self.lb_ActivityState.text = @"进行中";
            [self.image_ActivityState setImage:[UIImage imageNamed:@"activity_running"]];
        }
            break;
        case GNActivityStatusEnd:
        {
            self.lb_ActivityState.text = @"已结束";
            [self.image_ActivityState setImage:[UIImage imageNamed:@"activity_end"]];
        }
            break;
        default:
            break;
    }
    
    switch (activiety.essence) {
        case GNActivityEssenceCommon:
            self.btnPerfect.hidden  = YES;
            break;
            case GNActivityEssenceEssence:
            self.btnPerfect.hidden = NO;
            break;
        default:
            break;
    }
    // 隐藏我的团
//    if (activiety.enrolled_team) {
//        self.btnMyTeam.hidden  = NO;
//    }else{
//        self.btnMyTeam.hidden  = YES;
//    }
    
    self.btnIsMoney.font = [UIFont systemFontOfSize:20];
    switch (activiety.enroll_fee_type) {
        case GNActivityFeeTypeFee:
            self.btnIsMoney.text = @"免费";
            break;
        case GNActivityFeeTypeAA:
            self.btnIsMoney.text = @"AA制";
            break;
        case GNActivityFeeTypeToll:
            self.btnIsMoney.text =[NSString stringWithFormat:@"%@元",activiety.enroll_fee];
            //self.btnIsMoney.text =[NSString stringWithFormat:@"%d元",1000];
            break;
        default:
            break;
    }
   self.btnPerfect.text = @"精华";
    [self.btnPerfect setTextColor:kUIColorWithHexUint(GNUIColorOrange)];
    self.btnPerfect.layer.borderColor = [kUIColorWithHexUint(GNUIColorOrange) CGColor];
    self.btnPerfect.layer.borderWidth = 1;
    
    self.btnMyTeam.text = @"我的团";
    [self.btnMyTeam setTextColor:kUIColorWithHexUint(GNUIColorBlue)];
    self.btnMyTeam.layer.borderWidth = 1;
    self.btnMyTeam.layer.borderColor = [kUIColorWithHexUint(GNUIColorBlue) CGColor];
    
    
    self.lbActivityLocation.text = [activiety.brief_address stringByAppendingString:[GNApp distanceWithLon:[[activiety.location lastObject] doubleValue] lat:[[activiety.location firstObject] doubleValue]]];
    self.lbActivityTitle.text = activiety.title;
    
    if (self.btnMyTeam.hidden==YES&&self.btnPerfect.hidden==NO) {
        self.btnPerfectConstraint.constant = -50;
    }
}


@end
