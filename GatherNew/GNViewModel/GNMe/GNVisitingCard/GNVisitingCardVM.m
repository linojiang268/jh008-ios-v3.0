//
//  GNVisitingCardVM.m
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVisitingCardVM.h"
#import "GNVisitingCardNPS.h"

@implementation GNVisitingCardVM

- (instancetype)initWithUserId:(NSUInteger)userId gender:(GNGender)gender {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.gender = gender;
    }
    return self;
}

- (instancetype)initWithUserModel:(GNVisitingCardModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        self.gender = model.gender;
    }
    return self;
}

- (void)initModel {
    __weakify;
    self.userInfoResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        
        if (self.model) {
            self.userInfoResponse.success(nil, nil);
        }else {
            GNVisitingCardNPS *nps = [GNVisitingCardNPS NPSWithUserId:self.userId];
            [GNNetworkService GETWithService:nps success:^(id response, id model) {
                self.model = model;
                self.userInfoResponse.success(response, model);
            } error:self.userInfoResponse.error failure:self.userInfoResponse.failure];
        }
    }];
}

@end
