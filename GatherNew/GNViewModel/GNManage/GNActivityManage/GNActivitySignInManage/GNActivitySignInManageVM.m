//
//  GNActivitySignInManageVM.m
//  GatherNew
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivitySignInManageVM.h"

#import "GNActivityManageNPS.h"
#import "GNActivityCheckInListModel.h"

//默认值为0；0 – 获取未签到列表；1－获取已签到列表
#define CHECKED 1
#define UNCHECKED 0

@interface GNActivitySignInManageVM ()

@end

@implementation GNActivitySignInManageVM

+ (instancetype)initWithActivity:(NSInteger) activityId {
    GNActivitySignInManageVM* vm = [[GNActivitySignInManageVM alloc]init];
    vm.activityId = activityId;
    return vm;
}

- (void)initModel {
    self.notCheckInList = [NSMutableArray array];
    self.checkInList = [NSMutableArray array];
    self.searchList = [NSMutableArray array];
    
    __weakify;
    self.getCheckInListResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNActivityManageCheckInListNPS *nps = [GNActivityManageCheckInListNPS NPSWithActivity:self.activityId type:CHECKED page:self.checkInListPage size:kDefaultSize];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityCheckInListModel* model) {
            if(self.checkInListPage == kStartPage){
                [self.checkInList setArray:model.checkins];
            }else{
                [self.checkInList addObjectsFromArray:model.checkins];
            }
            self.checkInTotal =model.total;
            model.pages = (NSInteger)ceil(((float)model.total)/(float)kDefaultSize);
            self.getCheckInListResponse.success(response, model);
        } error:self.getCheckInListResponse.error failure:self.getCheckInListResponse.failure];
    }];
    
    [[RACObserve(self, checkInListPage) skip:2] subscribeNext:^(id x) {
        __strongify;
        [self.getCheckInListResponse start];
    }];
    
    
    self.getNotCheckInListResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNActivityManageCheckInListNPS *nps = [GNActivityManageCheckInListNPS NPSWithActivity:self.activityId type:UNCHECKED page:self.notCheckInListPage size:kDefaultSize];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityCheckInListModel* model) {
            if(self.notCheckInListPage == kStartPage){
                [self.notCheckInList setArray:model.checkins];
            }else{
                [self.notCheckInList addObjectsFromArray:model.checkins];
            }
            self.notCheckInTotal =model.total;
            model.pages = (NSInteger)ceil(((float)model.total)/(float)kDefaultSize);
            self.getNotCheckInListResponse.success(response, model);
        } error:self.getNotCheckInListResponse.error failure:self.getNotCheckInListResponse.failure];
    }];
    
    [[RACObserve(self, notCheckInListPage) skip:2] subscribeNext:^(id x) {
        __strongify;
        [self.getNotCheckInListResponse start];
    }];
    
    
//    self.getSearchSignInListResponse = [GNVMResponse responseWithTaskBlock:^{
//        __strongify;
//        GNActivityManageSearchSignInNPS *nps = [GNActivityManageSearchSignInNPS NPSWithActivity:self.activityId search:self.search];
//        [GNNetworkService GETWithService:nps success:^(id response, GNActivityCheckInListModel* model) {
//            
//            self.getSearchSignInListResponse.success(response, model);
//        } error:self.getSearchSignInListResponse.error failure:self.getSearchSignInListResponse.failure];
//    }];
}

-(void)manualCheckIn:(NSInteger)activity
                setp:(NSInteger)step
              userId:(NSInteger)userId
             approve:(BOOL)approve
             success:(GNSuccessHandler)success
               error:(GNErrorHandler)error
             failure:(GNFailureHandler)failure {
    [[GNVMResponse responseWithTaskBlock:^{
        GNActivityManageManualCheckInNPS *nps = [GNActivityManageManualCheckInNPS NPSWithActivity:activity step:step userId:userId approve:approve];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:nps.parameters];
        [params setObject:[nps createSign:nps.parameters] forKey:@"sign"];
        nps.parameters = params;
        [GNNetworkService POSTWithService:nps success:^(id response, id model) {
            success(response, model);
        } error:error failure:failure];
    }] start:YES success:success error:error failure:failure];
}

-(void)getQRCodeList:(NSInteger)activity
             success:(GNSuccessHandler)success
               error:(GNErrorHandler)error
             failure:(GNFailureHandler)failure {
    [[GNVMResponse responseWithTaskBlock:^{
        GNActivityManageQRCodeListNPS *nps = [GNActivityManageQRCodeListNPS NPSWithActivity:activity];
        [GNNetworkService GETWithService:nps success:^(id response, id model) {
            success(response, model);
        } error:error failure:failure];
    }] start:YES success:success error:error failure:failure];
}

-(void)searchSignInList:(NSInteger)activity
                 search:(NSString *)search
             success:(GNSuccessHandler)success
               error:(GNErrorHandler)error
             failure:(GNFailureHandler)failure {
    [[GNVMResponse responseWithTaskBlock:^{
        GNActivityManageSearchSignInNPS *nps = [GNActivityManageSearchSignInNPS NPSWithActivity:activity search: search];
        [GNNetworkService GETWithService:nps success:^(id response, id model) {
            success(response, model);
        } error:error failure:failure];
    }] start:YES success:success error:error failure:failure];
}


@end
