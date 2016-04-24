//
//  GNActivityLocationCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityLocationCell.h"
#import "GNActivityDetailsModel.h"

@interface GNActivityLocationCell ()
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;


@end

@implementation GNActivityLocationCell

- (void)awakeFromNib {
    self.lineViewHeight.constant = 0.5;
    [self.activityTimeLabel setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lineView setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.activityLocationLabel setTextColor:kUIColorWithHexUint(GNUIColorBlack)];
}

-(void)bindActivity:(GNActivityDetails*)activity{
    self.arrayLocation = activity.location;
    NSRange range = [activity.address rangeOfString:@"省"];
    if(range.location != NSNotFound){
        self.activityLocationLabel.text = [activity.address substringFromIndex:(range.location + range.length)];
    }else{
        self.activityLocationLabel.text = activity.address;
    }
    
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *beginTime = [formatter dateFromString:activity.begin_time];
    NSDate *endTime = [formatter dateFromString:activity.end_time];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDateComponents *beginC = [calender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginTime];
    NSDateComponents *endC = [calender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:endTime];
    
    if (beginC.year == endC.year && beginC.month == endC.month && beginC.day == endC.day) {
        self.activityTimeLabel.text = [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld-%02ld:%02ld",beginC.month,beginC.day,beginC.hour,beginC.minute,endC.hour,endC.minute];
    }else {
        self.activityTimeLabel.text = [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld-%ld月%ld日 %02ld:%02ld",beginC.month,beginC.day,beginC.hour,beginC.minute,endC.month,endC.day,endC.hour,endC.minute];
    }
    
    UITapGestureRecognizer *tapGestShowLocations = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLocations)];
    [self.activityLocationLabel addGestureRecognizer:tapGestShowLocations];
    [self.activityLocationLabel setUserInteractionEnabled:YES];
}


- (void)showLocations{
    if ([self.delegate respondsToSelector:@selector(intoMapShowLocaton:)]) {
        [self.delegate intoMapShowLocaton:self.arrayLocation];
    }
}


@end
