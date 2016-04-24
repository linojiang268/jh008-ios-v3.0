//
//  GNActivityManualFileVM.m
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualFileVM.h"

@interface GNActivityManualFileVM ()

@property (nonatomic, assign) NSInteger activityId;

@end

@implementation GNActivityManualFileVM

- (instancetype)initWithActivityId:(NSUInteger)activityId {
    self = [super init];
    if (self) {
        self.activityId = activityId;
    }
    return self;
}

- (void)initModel {
    
    self.fileArray = [[NSMutableArray alloc] init];
    self.dateArray = [[NSMutableArray alloc] init];
    
    __weakify;
    self.refreshResponse = [GNVMResponse responseWithTaskBlock:^{
        
        __strongify;
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/file/list"
                                             parameters:@{@"activity": kNumber(self.activityId),
                                                          @"page": kNumber(self.page)}
                                      mappingModelClass:[GNActivityManualFileModel class]];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityManualFileModel *model) {
            
            if (self.page == kStartPage) {
                [self.dateArray removeAllObjects];
            }
            
            for (GNActivityManualFileItemModel *item in model.files) {
                if (item.created_at.length > 10) {
                    NSString *date = [item.created_at substringToIndex:10];
                    if (![self.dateArray containsObject:date]) {
                        [self.dateArray addObject:date];
                    }
                }
            }
            
            if (self.page == kStartPage) {
                [self.fileArray setArray:model.files];
            }else {
                [self.fileArray addObjectsFromArray:model.files];
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
