//
//  GNActivityMyAlbumVM.m
//  GatherNew
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityMyAlbumVM.h"

@implementation GNActivityMyAlbumVM

- (instancetype)initWithActivityId:(NSUInteger)activityId {
    self = [super init];
    if (self) {
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
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/album/image/self/list"
                                             parameters:@{@"activity": kNumber(self.activityId),
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

- (GNVMResponse *)deleteResponse {
    if (!_deleteResponse) {
        _deleteResponse = [[GNVMResponse alloc] init];
    }
    return _deleteResponse;
}

- (void)deletePhotoWithIndex:(NSInteger)index {
    
    if (index >= self.albumArray.count) {
        return;
    }
    self.deletePhotoIndex = index;
    
    GNPhotoModel *model = [self.albumArray objectAtIndex:index];
    NSInteger imageId = model.id;
    __weakify;
    GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/album/image/self/remove"];
                                  mappingModelClass:[GNActivityAlbumListModel class];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:kNumber(self.activityId) forKey:@"activity"];
    [params setObject:[nps createSign:params] forKey:@"sign"];
    [params setObject:@[kNumber(imageId)] forKey:@"images"];
    
    nps.parameters = params;
    
    [GNNetworkService POSTWithService:nps success:^(id response, id model) {
        __strongify;
        self.deleteResponse.success(response, model);
    } error:^(id response, NSInteger code) {
        __strongify;
        self.deleteResponse.error(response, code);
    } failure:^(id req, NSError *error) {
        __strongify;
        self.deleteResponse.failure(req, error);
    }];
}

@end
