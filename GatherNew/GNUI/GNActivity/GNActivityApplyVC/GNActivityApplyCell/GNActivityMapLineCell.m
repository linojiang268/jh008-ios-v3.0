//
//  GNActivityMapLineCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityMapLineCell.h"
#import "GNActivityDetailsModel.h"

@implementation GNActivityMapLineCell

-(void)bindingModel:(id)model{
    GNActivityDetailsModel *detailsModel = model;
    [self.btnMapLine setImage:[UIImage imageNamed:@"activity_details_MapLine"] forState:UIControlStateNormal];
    self.arrayRoadmap = detailsModel.activity.roadmap;
}

- (IBAction)btnMapLineAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(intoMapShowLine:)]) {
        [self.delegate intoMapShowLine:self.arrayRoadmap];
    }
}
@end
