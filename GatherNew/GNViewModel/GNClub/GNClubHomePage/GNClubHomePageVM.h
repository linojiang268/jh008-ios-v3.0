//
//  GNClubHomePageVM.h
//  GatherNew
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNClubListModel.h"

@interface GNClubHomePageVM : GNVMBase

@property (nonatomic, assign) NSUInteger clubId;
@property (nonatomic, assign) GNClubMemberVisibility visibility;
@property (nonatomic, assign) GNClubMemberVisibility updateVisibility;
@property (nonatomic, strong) GNClubDetailModel *clubModel;
@property (nonatomic, assign) BOOL isFullInfo;

@property (nonatomic, assign) BOOL activityUpdated;
- (void)refreshActivityUpdateTime;
@property (nonatomic, assign) BOOL memberUpdated;
- (void)refreshMemberUpdatedTime;
@property (nonatomic, assign) BOOL newsUpdated;
- (void)refreshNewsUpdatedTime;
@property (nonatomic, assign) BOOL albumUpdated;
- (void)refreshAlbumUpdatedTime;
@property (nonatomic, assign) BOOL noticeUpdated;
- (void)refreshNoticeUpdatedTime;

- (instancetype)initWithClubId:(NSUInteger)clubId
                    visibility:(GNClubMemberVisibility)visibility;
- (instancetype)initWithClubModel:(GNClubDetailModel *)clubModel;

@property (nonatomic, strong) NSMutableArray *moduleArray;

@property (nonatomic, strong) NSDictionary *joinRequirements;
@property (nonatomic, strong) GNVMResponse *joinResponse;
@property (nonatomic, strong) GNVMResponse *exitResponse;
@property (nonatomic, strong) GNVMResponse *updatePrivacyResponse;
@property (nonatomic, strong) GNVMResponse *clubInfoResponse;

@property (nonatomic, strong) RACCommand *joinCommand;

@end
