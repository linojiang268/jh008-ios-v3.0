//
//  GNClubNewsVM.m
//  GatherNew
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubNewsVM.h"
#import "GNClubModuleNPS.h"

@implementation GNClubNewsVM

- (instancetype)initWithClubId:(NSUInteger)clubId {
    self = [super init];
    if (self) {
        self.clubId = clubId;
    }
    return self;
}

- (void)initModel {
    
    self.newsArray = [[NSMutableArray alloc] init];
    
    __weakify;
    self.refreshResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNClubNewsNPS *nps = [GNClubNewsNPS NPSWithClubId:self.clubId page:self.page];
        
        [GNNetworkService GETWithService:nps success:^(id response, GNClubNewsListModel *model) {
            if (self.page == kStartPage) {
                [self.newsArray setArray:model.news];
            }else {
                [self.newsArray addObjectsFromArray:model.news];
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
