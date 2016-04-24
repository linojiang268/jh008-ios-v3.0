//
//  GNActivitySignInVM.m
//  GatherNew
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivitySignInVM.h"
#import "NSString+GNExtension.h"

@interface GNActivitySignInVM ()

@end

@implementation GNActivitySignInVM

- (instancetype)initWithSignInIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.signInIdentifier = identifier;
    }
    return self;
}

- (void)initModel {
    
    __weakify;
    self.signInInfoResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/checkIn/list"
                                             parameters:@{@"qrcode_url": self.signInIdentifier}
                                      mappingModelClass:[GNActivitySignInModel class]];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivitySignInModel *model) {
            self.signInInfo = model;
            self.activityId = model.activity_id;
            self.signInInfoResponse.success(response, model);
        } error:self.signInInfoResponse.error failure:self.signInInfoResponse.failure];
    }];
    
    self.signInResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        
        if (![NSString isBlank:self.signInInfo.ver]) {
            GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/checkIn/checkIn"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:kNumber(self.signInInfo.activity_id) forKey:@"activity_id"];
            [dict setObject:kNumber(self.signInInfo.step) forKey:@"step"];
            [dict setObject:self.signInInfo.ver forKey:@"ver"];
            [dict setObject:[nps createSign:dict] forKey:@"sign"];
            
            nps.parameters = dict;
            nps.mappingModelClass = [GNActivitySignInModel class];
            
            [GNNetworkService POSTWithService:nps success:^(id response, GNActivitySignInModel *model) {
                self.signInInfo.check_list = model.check_list;
                self.signInResponse.success(response, self.signInInfo);
            } error:self.signInResponse.error failure:self.signInResponse.failure];
        }
    }];
}

@end
