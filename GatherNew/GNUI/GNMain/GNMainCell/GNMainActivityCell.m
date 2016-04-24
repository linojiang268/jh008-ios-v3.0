//
//  GNMainActivityCell.m
//  GatherNew
//
//  Created by yuanjun on 15/9/18.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMainActivityCell.h"

@interface GNMainActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *activityCoverImage;
@property (weak, nonatomic) IBOutlet UIButton *activityStatus;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *activityInfo;

@end

@implementation GNMainActivityCell


-(void)setActivity:(GNActivities *)activity{
    _activity = activity;
    [self.activityCoverImage setImageWithURL:activity.cover_url];
    self.activityName.text = activity.title;
    
    
    
    if (activity.sub_status == 5) {//已结束
        [self.activityStatus setTitle:@"已结束" forState:UIControlStateNormal];
        [self.activityStatus setBackgroundImage:[UIImage imageNamed:@"activity_end"] forState:UIControlStateNormal];
    }else{
        if (activity.sub_status == 4 && activity.applicant_status == 3) {//进行中
            [self.activityStatus setTitle:@"报名成功" forState:UIControlStateNormal];
            [self.activityStatus setBackgroundImage:[UIImage imageNamed:@"activity_blue_flag"] forState:UIControlStateNormal];
        }else{
            if (activity.applicant_status == 1) {//审核中
                [self.activityStatus setTitle:@"待审核" forState:UIControlStateNormal];
                [self.activityStatus setBackgroundImage:[UIImage imageNamed:@"activity_running"] forState:UIControlStateNormal];
            }else if (activity.applicant_status == 2){//代缴费
                [self.activityStatus setTitle:@"未支付" forState:UIControlStateNormal];
                [self.activityStatus setBackgroundImage:[UIImage imageNamed:@"activity_running"] forState:UIControlStateNormal];
            }else{//待参加
                [self.activityStatus setTitle:@"报名成功" forState:UIControlStateNormal];
                [self.activityStatus setBackgroundImage:[UIImage imageNamed:@"activity_blue_flag"] forState:UIControlStateNormal];
            }
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *beginTime = [formatter dateFromString:activity.begin_time];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *beginC = [calender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginTime];

    NSString* time = [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld",(long)beginC.month,(long)beginC.day,(long)beginC.hour,(long)beginC.minute];

    self.activityInfo.text = [NSString stringWithFormat:@"%@ | %@", time, activity.address];
}


- (void)awakeFromNib {
    self.activityCoverImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

@end
