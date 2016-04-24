//
//  GNClubVM.m
//  GatherNew
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubVM.h"
#import "GNClubModuleNPS.h"

@implementation GNClubVM

- (void)initModel {
    
    self.clubArray = [[NSMutableArray alloc] init];
    [GNCacheService modelWithClass:[GNClubListModel class] success:^(id response, GNClubListModel *model) {
        [self.clubArray addObjectsFromArray:model.teams];
    } error:^(id response, NSInteger code) {
        
    }];
    
    __weakify;
    self.refreshResponse = [GNVMResponse responseWithTaskBlock:^{

        __strongify;
        GNClubListNPS *nps = [GNClubListNPS NPSWithKeyword:self.keyword page:self.page];
        [GNNetworkService GETWithService:nps success:^(id response, GNClubListModel *model) {
            if (self.page == kStartPage) {
                [self.clubArray setArray:model.teams];
            }else {
                [self.clubArray addObjectsFromArray:model.teams];
            }
            self.refreshResponse.success(response, model);
        } error:self.refreshResponse.error failure:self.refreshResponse.failure];
    }];
    
    [[RACObserve(self, page) skip:2] subscribeNext:^(id x) {
        __strongify;
        
        [self.refreshResponse start];
    }];
}

@end
