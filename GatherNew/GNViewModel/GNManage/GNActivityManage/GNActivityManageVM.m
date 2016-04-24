//
//  GNActivityManageVM.m
//  GatherNew
//
//  Created by Culmore on 15/10/2.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManageVM.h"
#import "GNActivityManageNPS.h"
#import "GNActivityManageListModel.h"

@interface GNActivityManageVM ()

@property(nonatomic, strong) GNVMResponse * getActivitySendMessageResponse;
@property(assign, nonatomic) NSInteger activityId;
@property(strong, nonatomic) NSString* content;

@end


@implementation GNActivityManageVM


- (instancetype)init {
    self = [super init];
    self.activityList = [[NSMutableArray alloc]init];
    
    __weakify;
    self.getActivityListResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNActivityManageListNPS *nps = [GNActivityManageListNPS NPSWithPage:self.page size:kDefaultSize];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityManageListModel* model) {
            if(self.page == kStartPage){
                [self.activityList setArray:model.activities];
            }else{
                [self.activityList addObjectsFromArray:model.activities];
            }
            model.pages = (NSInteger)ceil(((float)model.total_num)/(float)kDefaultSize);
            self.getActivityListResponse.success(response, model);
        } error:self.getActivityListResponse.error failure:self.getActivityListResponse.failure];
    }];
    
    [[RACObserve(self, page) skip:2] subscribeNext:^(id x) {
        __strongify;
        [self.getActivityListResponse start];
    }];
    
    return self;
}



-(void)getLeftMessageForActivity:(NSInteger)activity
                      success:(GNSuccessHandler)success
                        error:(GNErrorHandler)error
                      failure:(GNFailureHandler)failure {
    __weakify;
    self.activityId = activity;
    if(!self.getActivityLeftMessageResponse){
        self.getActivityLeftMessageResponse = [GNVMResponse responseWithTaskBlock:^{
            __strongify;
            GNActivityManageGetLeftMessageNPS *nps = [GNActivityManageGetLeftMessageNPS NPSWithActivity:self.activityId];
            [GNNetworkService GETWithService:nps success:^(id response, id model) {
                self.getActivityLeftMessageResponse.success(response, model);
            } error:self.getActivityLeftMessageResponse.error failure:self.getActivityLeftMessageResponse.failure];
        }];
    }
    [self.getActivityLeftMessageResponse start:YES success:success error:error failure:failure];
}



-(void)sendMessageForActivity:(NSInteger)activity
                      content:(NSString*)content
                      success:(GNSuccessHandler)success
                        error:(GNErrorHandler)error
                      failure:(GNFailureHandler)failure {
    __weakify;
    self.activityId = activity;
    self.content = content;
    if(!self.getActivitySendMessageResponse){
        self.getActivitySendMessageResponse = [GNVMResponse responseWithTaskBlock:^{
            __strongify;
            GNActivityManageSendMessageNPS *nps = [GNActivityManageSendMessageNPS NPSWithActivity:self.activityId content:self.content];
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:nps.parameters];
            [params setObject:[nps createSign:nps.parameters] forKey:@"sign"];
            nps.parameters = params;

            [GNNetworkService POSTWithService:nps success:^(id response, id model) {
                
                self.getActivitySendMessageResponse.success(response, model);
            } error:self.getActivitySendMessageResponse.error failure:self.getActivitySendMessageResponse.failure];
        }];
    }
    [self.getActivitySendMessageResponse start:YES success:success error:error failure:failure];
}


@end
