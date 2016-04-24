//
//  GNActivityDetailsVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityDetailsVM.h"
#import "GNActivityNPS.h"

@implementation GNActivityDetailsVM

-(void)initModel{
    
    __weakify;
    self.getActivityDataResponse = [GNVMResponse responseWithTaskBlock:^{
       
        __strongify;
        GNActivityDetailsNPS *nps = [GNActivityDetailsNPS NPSWithActivityID:self.activityId];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityDetailsModel *model) {
            self.detailsModel = model;
            self.getActivityDataResponse.success(response, model);
        } error:self.getActivityDataResponse.error failure:self.getActivityDataResponse.failure];
    }];
    
    self.applyResultResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNActivityApplyNPS *nps = [GNActivityApplyNPS NPSWithActivityId:self.detailsModel.activity.id info:self.applyInfo];
        [GNNetworkService POSTWithService:nps success:self.applyResultResponse.success error:self.applyResultResponse.error failure:self.applyResultResponse.failure];
        
    }];
    
    self.getOrderInfoResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/applicant/payment/info"
                                             parameters:@{@"activity_id": kNumber(self.detailsModel.activity.id)}];
        [GNNetworkService GETWithService:nps success:self.getOrderInfoResponse.success error:self.getOrderInfoResponse.error failure:self.getOrderInfoResponse.failure];
    }];
}

@end
