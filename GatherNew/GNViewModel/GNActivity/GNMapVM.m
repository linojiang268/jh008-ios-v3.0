//
//  GNMapVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/24.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMapVM.h"
#import "GNMapNPS.h"
#import "GNActivityListModel.h"
#import "GNMapPersonModel.h"

@implementation GNMapVM
-(void)initModel{
    
    self.dist = 50;
    __weakify;
    self.getLocationActivityResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNMapNPS *nps = [GNMapNPS NPSWithlat:self.lat lng:self.lng dist:self.dist];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityListModel *model) {
            self.getLocationActivityResponse.success(response, model);
        } error:self.getLocationActivityResponse.error failure:self.getLocationActivityResponse.failure];
    }];
    
    
    self.getActivityPersonResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNMapPersonNPS *nps = [GNMapPersonNPS NPSWithActivityID:self.activityID lat:self.lat lng:self.lng];
        [GNNetworkService GETWithService:nps success:^(id response, GNMapPersonModel *model) {
            
            self.arrayMembers = model.members;
            self.getActivityPersonResponse.success(response, model);
        }error:self.getActivityPersonResponse.error failure:self.getActivityPersonResponse.failure];
        
    }];
}
@end
