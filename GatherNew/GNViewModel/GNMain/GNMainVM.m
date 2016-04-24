//
//  GNMainVM.m
//  GatherNew
//
//  Created by yuanjun on 15/9/18.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMainVM.h"
#import "GNRecentActivityNPS.h"

@interface GNMainVM ()

@end

@implementation GNMainVM

-(void)initModel{
    __weakify;
    self.bannerArray = [[NSMutableArray alloc] init];
    self.clubArray = [[NSMutableArray alloc] init];
    self.activityArray = [[NSMutableArray alloc] init];
    
    self.refreshResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        
        [self refresh];
    }];
    
}

- (void)refresh {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    /// banner
    GNNPSBase *bannerNPS = [[GNNPSBase alloc] initWithURL:@"/api/banner/list"
                                               parameters:@{@"city": kNumber(kUserCityID)}
                                        mappingModelClass:[GNMainBannerListModel class]];
    [GNNetworkService GETWithService:bannerNPS success:^(id response, GNMainBannerListModel *model) {
        [self.bannerArray setArray:model.banners];
        dispatch_group_leave(group);
    } error:^(id response, NSInteger code) {
        dispatch_group_leave(group);
    } failure:^(id req, NSError *error) {
        dispatch_group_leave(group);
    }];
    
    /// 社团
    
    GNNPSBase *clubNPS = [[GNNPSBase alloc] initWithURL:@"/api/team/self/list"
                                               parameters:@{@"city": kNumber(kUserCityID)}
                                        mappingModelClass:[GNClubListModel class]];
    [GNNetworkService GETWithService:clubNPS success:^(id response, GNClubListModel *model) {
        [self.clubArray setArray:model.teams];
        dispatch_group_leave(group);
    } error:^(id response, NSInteger code) {
        dispatch_group_leave(group);
    } failure:^(id req, NSError *error) {
        dispatch_group_leave(group);
    }];
    
    /// 活动
    GNRecentActivityNPS *activityNPS = [GNRecentActivityNPS NPSWithNoneParams];
    [GNNetworkService GETWithService:activityNPS success:^(id response, GNActivityListModel *model) {
        [self.activityArray setArray:model.activities];
        dispatch_group_leave(group);
    } error:^(id response, NSInteger code) {
        dispatch_group_leave(group);
    } failure:^(id req, NSError *error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.refreshResponse.success(nil,nil);
    });
}

@end
