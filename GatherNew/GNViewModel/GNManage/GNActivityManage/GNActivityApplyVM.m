//
//  GNActivityApplyVM.m
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityApplyVM.h"
#import "GNActivityManageNPS.h"
#import "GNActivityApplyListModel.h"

@interface GNActivityApplyVM ()

@property(nonatomic, strong) GNVMResponse * setApplyNoteResponse;
@property(nonatomic, strong) GNVMResponse * applicantApproveResponse;

@property(nonatomic, assign) NSInteger size;


@end

@implementation GNActivityApplyVM

- (instancetype)initWithActivity:(NSInteger) activityId status:(NSInteger)status {
    self = [super init];
    self.applyList = [[NSMutableArray alloc]init];
    self.activityId = activityId;
    self.applyStatus = status;
    self.size = DEFAULT_APPLY_LIST_SIZE;
    
    __weakify;
    self.getApplyListResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        NSInteger size = self.size;
        NSInteger beginID = 0;
        GNActivityApplyModel* who = [self.applyList lastObject];
        if(who && (self.page != kStartPage)){
            beginID = who.id;
        }
        
        GNActivityManageApplyListNPS *nps = [GNActivityManageApplyListNPS NPSWithActivity:self.activityId status:self.applyStatus size:size  beginID:beginID];
        [GNNetworkService GETWithService:nps success:^(id response, GNActivityApplyListModel *model) {
            if(self.page == kStartPage){
                [self.applyList setArray:model.applicants];
            }else{
                [self.applyList addObjectsFromArray:model.applicants];
            }
            
            self.total = model.total;
            model.pages = (NSInteger)ceil(((float)model.total)/(float)DEFAULT_APPLY_LIST_SIZE);
            self.getApplyListResponse.success(response, model);
        } error:self.getApplyListResponse.error failure:self.getApplyListResponse.failure];
    }];
    

    [[RACObserve(self, page) skip:2] subscribeNext:^(id x) {
        __strongify;
        [self.getApplyListResponse start];
    }];

    return self;
}




- (void) setApplyApplicant:(NSInteger)applicant
                      note:(NSString*)content
                   success:(GNSuccessHandler)success
                     error:(GNErrorHandler)error
                   failure:(GNFailureHandler)failure {
     __weakify;
    self.setApplyNoteResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNActivityManageApplyNoteNPS *nps = [GNActivityManageApplyNoteNPS NPSWithActivity:self.activityId applicant:applicant content:content];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:nps.parameters];
        [params setObject:[nps createSign:nps.parameters] forKey:@"sign"];
        nps.parameters = params;
        
        [GNNetworkService POSTWithService:nps success:self.setApplyNoteResponse.success error:self.setApplyNoteResponse.error failure:self.setApplyNoteResponse.failure];
    }];
    [self.setApplyNoteResponse start:YES success:success error:error failure:failure];
}


- (void) setApplyApplicantApprove:(NSArray*)applicantIds
                           status:(BOOL)approveOrRefuse
                          success:(GNSuccessHandler)success
                            error:(GNErrorHandler)error
                          failure:(GNFailureHandler)failure {
    __weakify;
    self.applicantApproveResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNActivityManageApplyApproveNPS *nps = [GNActivityManageApplyApproveNPS NPSWithActivity:self.activityId applicantIds:applicantIds status:approveOrRefuse];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:@(self.activityId) forKey:@"activity"];
        [params setObject:[nps createSign:params] forKey:@"sign"];
        [params setObject:applicantIds forKey:@"applicants"];
        
        nps.parameters = params;
        
        [GNNetworkService POSTWithService:nps success:self.applicantApproveResponse.success error:self.applicantApproveResponse.error failure:self.applicantApproveResponse.failure];
    }];
    [self.applicantApproveResponse start:YES success:success error:error failure:failure];
}





@end
