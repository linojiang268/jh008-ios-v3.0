//
//  GNClubActiveAlbumVM.m
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubActiveAlbumVM.h"
#import "GNClubModuleNPS.h"

@implementation GNClubActiveAlbumVM

- (instancetype)initWithClubId:(NSUInteger)clubId {
    self = [super init];
    if (self) {
        self.clubId = clubId;
    }
    return self;
}

- (void)initModel {
    
    self.activityArray = [[NSMutableArray alloc] init];
    
    __weakify;
    self.refreshResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNClubAlbumNPS *nps = [GNClubAlbumNPS NPSWithClubId:self.clubId page:self.page];
        
        [GNNetworkService GETWithService:nps success:^(id response, GNClubAlbumListModel *model) {
            if (self.page == kStartPage) {
                [self.activityArray setArray:model.activities];
            }else {
                [self.activityArray addObjectsFromArray:model.activities];
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
