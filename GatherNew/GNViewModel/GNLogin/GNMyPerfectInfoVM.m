//
//  GNMyPerfectInfoVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMyPerfectInfoVM.h"
#import "GNMyPerfectInfoNPS.h"
#import "GNExistNPS.h"
#import "GNUpdatePerfectInfoNPS.h"


@implementation GNMyPerfectInfoVM

- (void)initModel {
    
    self.saveResponse = [[GNVMResponse alloc] init];
    
    __weakify;
    self.getPerfectInfoResponse = [GNVMResponse responseWithTaskBlock:^{
        
        __strongify;
        GNMyPerfectInfoNPS *nps = [GNMyPerfectInfoNPS NPSInit];
        [GNNetworkService GETWithService:nps success:^(id response, GNPerfectInfoModel *model) {
            self.getPerfectInfoResponse.success(response, model);
        } error:self.getPerfectInfoResponse.error failure:self.getPerfectInfoResponse.failure];
    }];
    
    self.saveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        GNUpdatePerfectInfoNPS *nps = [GNUpdatePerfectInfoNPS NPSWithPassword:self.passWord name:self.name sex:self.sex age:self.age tagids:self.arrayTag headPortrait:UIImagePNGRepresentation(self.headPortrait)];
        
        
        [GNNetworkService POSTWithService:nps success:^(id response, id model) {
            
            self.saveResponse.success(response, model);
            
        } error:self.saveResponse.error failure:self.saveResponse.failure];
        
        return [RACSignal empty];
    }];
    
    self.existResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNExistNPS *nps = [GNExistNPS NPSInit];
        [GNNetworkService GETWithService:nps success:^(id response, id model) {
            self.existResponse.success(response, model);
        } error:self.existResponse.error failure:self.existResponse.failure];
    }];
    
}

@end
