//
//  GNActivityManageVM.h
//  GatherNew
//
//  Created by Culmore on 15/10/2.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNActivityManageVM : GNVMBase

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray* activityList;

@property(nonatomic, strong) GNVMResponse * getActivityListResponse;
@property(nonatomic, strong) GNVMResponse * getActivityLeftMessageResponse;


-(void)getLeftMessageForActivity:(NSInteger)activity
                         success:(GNSuccessHandler)success
                           error:(GNErrorHandler)error
                         failure:(GNFailureHandler)failure;

-(void)sendMessageForActivity:(NSInteger)activity
                      content:(NSString*)content
                      success:(GNSuccessHandler)success
                        error:(GNErrorHandler)error
                      failure:(GNFailureHandler)failure;
@end
