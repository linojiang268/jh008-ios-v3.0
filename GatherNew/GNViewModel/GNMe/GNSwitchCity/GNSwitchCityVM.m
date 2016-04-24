//
//  GNSwitchCityVM.m
//  GatherNew
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNSwitchCityVM.h"
#import "GNNPSBase.h"
#import "GNCityModel.h"

@implementation GNSwitchCityVM

- (void)initModel {
    __weakify;
    self.cityResponse = [GNVMResponse responseWithTaskBlock:^{
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"api/city/list"
                                            requestType:GNNetworkRequestTypeGetCacheAfterRefreshAndCache
                                      mappingModelClass:[GNCitiesModel class]
                                   localCacheIdentifier:@"cities"];
        
        __strongify;
        [GNNetworkService GETWithService:nps success:^(id response, id model) {
            self.model = model;
            self.cityResponse.success(response,model);
        } error:self.cityResponse.error failure:self.cityResponse.failure];
    }];
}

- (void)switchCity:(GNCityModel *)model {
    [GNApp switchUserCity:model];
}

@end
