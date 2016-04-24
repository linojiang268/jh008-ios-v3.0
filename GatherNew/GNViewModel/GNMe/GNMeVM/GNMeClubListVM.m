//
//  GNMeClubListVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeClubListVM.h"
#import "GNMeNPS.h"

@implementation GNMeClubListVM

-(void)initModel{
    __weakify;
    self.getClubListResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        
        GNCityModel *city = [GNApp userCity] ;
        
        GNMeClubListNPS *nps = [GNMeClubListNPS NPSWithClubCity:city.id isCount:NO];
        
        [GNNetworkService GETWithService:nps success:^(id response, GNMeClubListModel *model) {
            
            self.clubListModel = model;
            self.getClubListResponse.success(response, model);
        } error:self.getClubListResponse.error failure:self.getClubListResponse.failure];
    }];

}

@end
