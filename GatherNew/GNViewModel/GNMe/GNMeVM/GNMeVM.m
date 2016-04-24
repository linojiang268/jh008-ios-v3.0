//
//  GNMeVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeVM.h"
#import "GNMeNPS.h"

@implementation GNMeVM

-(void)initModel{

    __weakify;
    self.getClubDataResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        
        GNCityModel *city = [GNApp userCity] ;
        
        GNMeNPS *nps = [GNMeNPS NPSWithClubCity:city.id isCount:YES];
        
        [GNNetworkService GETWithService:nps success:^(id response, id model) {
            self.getClubDataResponse.success(response, model);
        } error:self.getClubDataResponse.error failure:self.getClubDataResponse.failure];
    }];
    
    

    self.getActivityDataResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNMeActivityNPS *nps = [GNMeActivityNPS NPSWithActivityNumber];
        
        [GNNetworkService GETWithService:nps success:^(id response, id model) {
            self.getActivityDataResponse.success(response, model);
        } error:self.getActivityDataResponse.error failure:self.getActivityDataResponse.failure];
    }];
    
}

@end
