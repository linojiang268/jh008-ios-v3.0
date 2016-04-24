//
//  GNActivityDetailManualCell.m
//  GatherNew
//
//  Created by yuanjun on 15/9/21.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityDetailManualCell.h"


@interface GNActivityDetailManualCell ()
@property (weak, nonatomic) IBOutlet UIButton *activityFlowBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityAlbumBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityFileBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityRoadMapBtn;
@property (weak, nonatomic) IBOutlet UILabel *activityFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityAlbumLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityFileLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityRoadMapLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;


@property (strong, nonatomic) GNActivityDetails* activity;

@end

@implementation GNActivityDetailManualCell



- (void)bindActivity:(GNActivityDetails*)activity {
    self.activity = activity;
    self.activityAlbumLabel.text = [NSString stringWithFormat:@"照片墙(%ld)",(long)(activity.activity_album_count)];
    self.activityFileLabel.text = [NSString stringWithFormat:@"文件(%ld)",(long)(activity.activity_file_count)];

}


- (IBAction)onFlowClicked:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(showActivityFlow:)]){
        [self.delegate showActivityFlow:nil];
    }
}


- (IBAction)onAblumClicked:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(showActivityAblum:)]){
        [self.delegate showActivityAblum:nil];
    }
}


- (IBAction)onFileClicked:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(showActivityFile:)]){
        [self.delegate showActivityFile:nil];
    }
}


- (IBAction)onRoadMapClicked:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(showActivityRoadMap:)]){
        [self.delegate showActivityRoadMap:nil];
    }
}


- (void)awakeFromNib {
    [self.titleLabel setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lineView setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    self.lineViewHeight.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
