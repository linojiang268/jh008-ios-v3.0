//
//  GNActivityVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityVM.h"
#import "GNActivityNPS.h"
#import "GNActivityListModel.h"
#import "GNClubModuleNPS.h"

@implementation GNActivityVM

- (instancetype)initActiveList {
    self = [super init];
    if (self) {
        self.activityType = GNActivityTypeActivity;
    }
    return self;
}

- (instancetype)initClubActiveListWithClubId:(NSUInteger)clubId {
    self = [self initActiveList];
    if (self) {
        self.activityType = GNActivityTypeClub;
        self.clubId = clubId;
    }
    return self;
}

- (void)initModel {

    self.activityArray = [[NSMutableArray alloc] init];
    if(self.activityType == GNActivityTypeActivity){
        [GNCacheService modelWithClass:[GNActivityListModel class] success:^(id response, GNActivityListModel *model) {
            [self.activityArray addObjectsFromArray:model.activities];
        } error:^(id response, NSInteger code) {
            
        }];
    }
    __weakify;
    self.refreshActivityResponse = [GNVMResponse responseWithTaskBlock:^{
        
        __strongify;
        GNNPSBase *nps = nil;
        
        if(self.activityType == GNActivityTypeActivity){
            nps = [GNActivityNPS NPSWithKeyword:self.keyword page:self.page size:kDefaultSize];
        }else {
            nps = [GNClubActivityListNPS NPSWithClubId:self.clubId page:self.page];
        }
        
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityListModel *model) {
            if (self.page == kStartPage) {
                [self.activityArray setArray:model.activities];
            }else {
                [self.activityArray addObjectsFromArray:model.activities];
            }
            self.refreshActivityResponse.success(response, model);
        } error:self.refreshActivityResponse.error failure:self.refreshActivityResponse.failure];
    }];
    
    
    [[RACObserve(self, page) skip:2] subscribeNext:^(id x) {
        __strongify;
        
        [self.refreshActivityResponse start];
    }];
}

@end
