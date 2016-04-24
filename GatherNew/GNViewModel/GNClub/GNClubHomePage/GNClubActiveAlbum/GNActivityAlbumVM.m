//
//  GNActivityAlbumVM.m
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityAlbumVM.h"

@interface GNActivityAlbumVM ()

@end

@implementation GNActivityAlbumVM

- (instancetype)initWithType:(GNActivityAlbumType)type
                  activityId:(NSUInteger)activityId
{
    self = [super init];
    if (self) {
        self.type = type;
        self.activityId = activityId;
    }
    return self;
}

- (void)initModel {
    
    self.albumArray = [[NSMutableArray alloc] init];
    
    __weakify;
    self.refreshResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        self.loading = YES;
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/album/image/list"
                                             parameters:@{@"activity": kNumber(self.activityId),
                                                          @"creator_type": kNumber(self.type),
                                                          @"page": kNumber(self.page)}
                                      mappingModelClass:[GNActivityAlbumListModel class]];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityAlbumListModel *model) {
            self.loading = NO;
            if (self.page == kStartPage) {
                [self.albumArray setArray:model.images];
            }else {
                [self.albumArray addObjectsFromArray:model.images];
            }
            self.refreshResponse.success(response, model);
        } error:^(id response, NSInteger code) {
            self.loading = NO;
            self.refreshResponse.error(response, code);
        } failure:^(id req, NSError *error) {
            self.loading = NO;
            self.refreshResponse.failure(req, error);
        }];
    }];
    
    [[RACObserve(self, page) skip:2] subscribeNext:^(id x) {
        __strongify;
        [self.refreshResponse start];
    }];
}

@end
