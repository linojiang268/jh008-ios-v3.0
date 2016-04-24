//
//  GNActivityApplyVM.h
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

#define APPLY   1
#define FEE     2
#define SUCCESS 3
#define DEFAULT_APPLY_LIST_SIZE 20

@interface GNActivityApplyVM : GNVMBase

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) NSInteger activityId;
@property(nonatomic, assign) NSInteger applyStatus;

@property(nonatomic, assign) NSInteger total;

@property(nonatomic, strong) NSMutableArray * applyList;
@property(nonatomic, strong) GNVMResponse * getApplyListResponse;



- (instancetype)initWithActivity:(NSInteger) activityId status:(NSInteger)status;

- (void) setApplyApplicant:(NSInteger)applicant
              note:(NSString*)note
              success:(GNSuccessHandler)success
                error:(GNErrorHandler)error
              failure:(GNFailureHandler)failure;

- (void) setApplyApplicantApprove:(NSArray*)applicantIds
                           status:(BOOL)approveOrRefuse
                          success:(GNSuccessHandler)success
                            error:(GNErrorHandler)error
                          failure:(GNFailureHandler)failure;



@end
