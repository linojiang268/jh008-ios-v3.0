//
//  GNActivitySignInManageVM.h
//  GatherNew
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"

@interface GNActivitySignInManageVM : GNVMBase

@property(nonatomic, assign) NSInteger activityId;


@property(nonatomic, assign) NSInteger notCheckInListPage;
@property(nonatomic, assign) NSInteger checkInListPage;
@property(nonatomic, assign) NSString * search;


@property(nonatomic, assign) NSInteger notCheckInTotal;
@property(nonatomic, assign) NSInteger checkInTotal;


@property (nonatomic, strong) NSMutableArray *notCheckInList;
@property (nonatomic, strong) NSMutableArray *checkInList;
@property (nonatomic, strong) NSMutableArray *searchList;

@property(nonatomic, strong) GNVMResponse * getCheckInListResponse;
@property(nonatomic, strong) GNVMResponse * getNotCheckInListResponse;



+ (instancetype)initWithActivity:(NSInteger) activityId;

-(void)manualCheckIn:(NSInteger)activity
                setp:(NSInteger)step
              userId:(NSInteger)userId
             approve:(BOOL)approve
             success:(GNSuccessHandler)success
               error:(GNErrorHandler)error
             failure:(GNFailureHandler)failure;

-(void)getQRCodeList:(NSInteger)activity
             success:(GNSuccessHandler)success
               error:(GNErrorHandler)error
             failure:(GNFailureHandler)failure;

-(void)searchSignInList:(NSInteger)activity
                 search:(NSString *)search
                success:(GNSuccessHandler)success
                  error:(GNErrorHandler)error
                failure:(GNFailureHandler)failure;

@end
