//
//  GNMeActivityListVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeActivityListVM.h"
#import "GNMeNPS.h"
#import "GNActivityListModel.h"

@implementation GNMeActivityListVM

-(void)initModel{
    
    self.activityDateArray = [NSMutableArray array];
    self.activityArray = [NSMutableArray array];
    
    __weakify;
    self.getActivityListReponese = [GNVMResponse responseWithTaskBlock:^{
        __strongify;

        NSString *type = @"";
        switch (self.activityListType) {
            case GNMeActivityListType_All:
                type = @"All";
                break;
            case GNMeActivityListType_End:
                type = @"End";
                break;
            case GNMeActivityListType_NotBeginning:
                type = @"NotBeginning";
                break;
            case GNMeActivityListType_WaitPay:
                type = @"WaitPay";
                break;
            case GNMeActivityListType_Auditing:
                type = @"Auditing";
                break;
            case GNMeActivityListType_Beginning:
                type = @"Beginning";
                break;
            case GNMeActivityListType_Pending_Confirm:
                type = @"Enrolling";
                break;
            default:
                break;
        }
        
        GNMeActivityListNPS *nps = [GNMeActivityListNPS NPSWithActivityType:type page:self.page];
        
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityListModel *model) {
            
            if (self.page == kStartPage) {
                [self.activityDateArray removeAllObjects];
            }
            
            for (GNActivities *info in model.activities) {
                if (info.begin_time.length > 10) {
                    if (![self.activityDateArray containsObject:[info.begin_time substringToIndex:10]] ) {
                        [self.activityDateArray addObject:[info.begin_time substringToIndex:10]];
                    }
                }
            }

            if(self.page == kStartPage){
                [self.activityArray setArray:model.activities];
            }else{
                [self.activityArray addObjectsFromArray:model.activities];
            }
            
            self.getActivityListReponese.success(response, model);
        } error:self.getActivityListReponese.error failure:self.getActivityListReponese.failure];
    }];
    
    [[RACObserve(self, page) skip:2] subscribeNext:^(id x) {
        __strongify;
        
        [self.getActivityListReponese start];
    }];
}

@end
