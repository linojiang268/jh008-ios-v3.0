//
//  GNActivityManualVM.m
//  GatherNew
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualVM.h"

@implementation GNActivityManualVM

- (instancetype)initWithActivityId:(NSUInteger)activityId {
    self = [super init];
    if (self) {
        self.activityId = activityId;
    }
    return self;
}

- (void)initModel {
    
    __weakify;
    self.getManualInfoResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/checkin/info"
                                             parameters:@{@"activity": kNumber(self.activityId)}
                                      mappingModelClass:[GNActivityDetailsModel class]];
        [GNNetworkService GETWithService:nps success:^(id response, id model) {
            self.manualModel = model;
            self.getManualInfoResponse.success(response,model);
        } error:self.getManualInfoResponse.error failure:self.getManualInfoResponse.failure];
    }];
}

@end
