//
//  GNActivityScoreVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityScoreVM.h"
#import "GNActivityNPS.h"
#import "GNActivityScoreModel.h"

@implementation GNActivityScoreVM

-(void)initModel{
    
    __weakify;
    self.getActivityScoreResponse = [GNVMResponse responseWithTaskBlock:^{
        GNActivityScoreNPS *nps = [GNActivityScoreNPS NPSWithScoreData];
        __strongify;
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityScoreModel *model) {
            self.getActivityScoreResponse.success(response,model);
            
        } error:self.getActivityScoreResponse.error failure:self.getActivityScoreResponse.failure];
    }];
    
    
    self.commitResponse = [[GNVMResponse alloc]init];
    
    self.commitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        GNActivityScoreNPS *nps = [GNActivityScoreNPS NPSWithActivityID:self.activity score:self.score attributes:self.attributes memo:self.memo];
        [GNNetworkService POSTWithService:nps success:^(id response, id model) {
            self.commitResponse.success(response,model);
            
        } error:self.commitResponse.error failure:self.commitResponse.failure];
        
        return [RACSignal empty];
    }];
    
}

@end
