//
//  GNMemberVM.m
//  GatherNew
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMemberVM.h"
#import "GNClubModuleNPS.h"

@interface GNMemberVM ()

@property (nonatomic, assign) GNMemberType type;

@end

@implementation GNMemberVM

- (instancetype)initWithType:(GNMemberType)type typeId:(NSUInteger)typeId {
    self = [super init];
    if (self) {
        self.type = type;
        self.typeId = typeId;
    }
    return self;
}

- (void)initModel {
    
    self.memberArray = [[NSMutableArray alloc] init];
    
    __weakify;
    self.refreshResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        
        GNNPSBase *nps = nil;
        if (self.type == GNMemberTypeClub) {
            nps = [GNClubMemberNPS NPSWithClubId:self.typeId page:self.page];
        }else {
            nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/member/list"
                                      parameters:@{@"activity_id": kNumber(self.typeId),
                                                   @"page": kNumber(self.page)}
                               mappingModelClass:[GNMemberListModel class]];
        }
        
        [GNNetworkService GETWithService:nps success:^(id response, GNMemberListModel *model) {
            
            if (self.page == kStartPage) {
                [self.memberArray setArray:model.members];
            }else {
                [self.memberArray addObjectsFromArray:model.members];
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
