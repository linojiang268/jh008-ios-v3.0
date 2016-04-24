//
//  GNClubHomePageVM.m
//  GatherNew
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubHomePageVM.h"
#import "GNClubModuleNPS.h"
#import "GNClubModuleUpdateModel.h"
#import <CoreData+MagicalRecord.h>

@implementation GNClubHomePageVM

- (instancetype)initWithClubId:(NSUInteger)clubId visibility:(GNClubMemberVisibility)visibility {
    self = [super init];
    if (self) {
        self.clubId = clubId;
        self.visibility = visibility;
        self.isFullInfo = NO;
    }
    return self;
}

- (instancetype)initWithClubModel:(GNClubDetailModel *)clubModel {
    self = [super init];
    if (self) {
        self.clubModel = clubModel;
        self.clubId = clubModel.id;
        self.visibility = clubModel.visibility;
        self.isFullInfo = NO;
    }
    return self;
}

- (NSMutableArray *)moduleArray {
    if (!_moduleArray) {
        _moduleArray = [[NSMutableArray alloc] initWithArray:@[@{@"image_name": @"club_recent_active", @"title": @"近期活动"},
                                                               @{@"image_name": @"club_news", @"title": @"社团资讯"},
                                                               @{@"image_name": @"club_member", @"title": @"社团成员"},]];
    }
    if (_moduleArray) {
        if (self.clubModel.joined) {
            [_moduleArray addObjectsFromArray:@[@{@"image_name": @"club_album", @"title": @"相册"},
                                                @{@"image_name": @"club_barcode", @"title": @"社团分享"},
                                                //@{@"image_name": @"club_notice", @"title": @"通知"},
                                                @{@"image_name": @"club_privacy_setting", @"title": @"隐私设置"}]];
        }
    }
    
    return _moduleArray;
}

- (RACCommand *)joinCommand {
    if (!_joinCommand) {
        
        __weakify;
        _joinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            __strongify;
            
            [self.joinResponse start];
            
            return [RACSignal empty];
        }];
    }
    return _joinCommand;
}

- (GNVMResponse *)joinResponse {
    if (!_joinResponse) {
        
        __weakify;
        _joinResponse = [GNVMResponse responseWithTaskBlock:^{
            __strongify;
            GNJoinClubNPS *nps = [GNJoinClubNPS NPSWithClubId:self.clubId requirements:self.joinRequirements];
            [GNNetworkService POSTWithService:nps success:_joinResponse.success error:_joinResponse.error failure:_joinResponse.failure];
        }];
    }
    return _joinResponse;
}

- (GNVMResponse *)exitResponse {
    if (!_exitResponse) {
        
        __weakify;
        _exitResponse = [GNVMResponse responseWithTaskBlock:^{
            __strongify;
            GNExitClubNPS *nps = [GNExitClubNPS NPSWithClubId:self.clubId];
            [GNNetworkService POSTWithService:nps success:_exitResponse.success error:_exitResponse.error failure:_exitResponse.failure];
        }];
    }
    return _exitResponse;
}

- (GNVMResponse *)updatePrivacyResponse {
    if (!_updatePrivacyResponse) {
        __weakify;
        _updatePrivacyResponse = [GNVMResponse responseWithTaskBlock:^{
            __strongify;
            GNClubUpdatePrivacyNPS *nps = [GNClubUpdatePrivacyNPS NPSWithClubId:self.clubId visibility:self.updateVisibility];
            [GNNetworkService POSTWithService:nps success:_updatePrivacyResponse.success error:_updatePrivacyResponse.error failure:_updatePrivacyResponse.failure];
        }];
    }
    return _updatePrivacyResponse;
}

- (void)initModel {
    
    __weakify;
    self.clubInfoResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        if (self.clubModel) {
            self.clubInfoResponse.success(nil, self.clubModel);
        }
        GNClubDetailNPS *nps = [GNClubDetailNPS NPSWithClubId:self.clubId];
        [GNNetworkService GETWithService:nps success:^(id response, GNClubDetailModel *model) {
            self.clubModel = model;
            self.visibility = model.visibility;
            self.isFullInfo = YES;
            [self checkUpdate];
            self.clubInfoResponse.success(response,model);
        } error:self.clubInfoResponse.error failure:self.clubInfoResponse.failure];
    }];
}

- (void)checkUpdate {
    
    if (self.clubModel.joined) {
        GNClubModuleUpdateModel *model = [GNClubModuleUpdateModel MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %d and club_id == %d",kUserId, self.clubId]];
        if (model) {
            self.activityUpdated = model.activity_update_time < self.clubModel.activities_updated_at;
            self.memberUpdated   = model.member_update_time   < self.clubModel.members_updated_at;
            self.newsUpdated     = model.news_update_time     < self.clubModel.news_updated_at;
            self.albumUpdated    = model.album_update_time    < self.clubModel.albums_updated_at;
            self.noticeUpdated   = model.notice_update_time   < self.clubModel.notices_updated_at;
        }else {
            self.activityUpdated = self.clubModel.activities_updated_at > 0;
            self.memberUpdated   = self.clubModel.members_updated_at  > 0;
            self.newsUpdated     = self.clubModel.news_updated_at  > 0;
            self.albumUpdated    = self.clubModel.albums_updated_at  > 0;
            self.noticeUpdated   = self.clubModel.notices_updated_at  > 0;
        }
    }
}

- (void)refreshActivityUpdateTime {
    if (self.clubModel.joined) {
        GNClubModuleUpdateModel *model = [GNClubModuleUpdateModel MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %d and club_id == %d",kUserId, self.clubId]];
        if (model) {
            model.activity_update_time = [[NSDate date] timeIntervalSince1970];
        }else {
            model = [GNClubModuleUpdateModel MR_createEntity];
            model.user_id = kUserId;
            model.club_id = self.clubId;
            model.activity_update_time = [[NSDate date] timeIntervalSince1970];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            
        }];
    }
}

- (void)refreshMemberUpdatedTime {
    if (self.clubModel.joined) {
        GNClubModuleUpdateModel *model = [GNClubModuleUpdateModel MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %d and club_id == %d",kUserId, self.clubId]];
        if (model) {
            model.member_update_time = [[NSDate date] timeIntervalSince1970];
        }else {
            model = [GNClubModuleUpdateModel MR_createEntity];
            model.user_id = kUserId;
            model.club_id = self.clubId;
            model.member_update_time = [[NSDate date] timeIntervalSince1970];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            
        }];
    }
}

- (void)refreshNewsUpdatedTime {
    if (self.clubModel.joined) {
        GNClubModuleUpdateModel *model = [GNClubModuleUpdateModel MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %d and club_id == %d",kUserId, self.clubId]];
        if (model) {
            model.news_update_time = [[NSDate date] timeIntervalSince1970];
        }else {
            model = [GNClubModuleUpdateModel MR_createEntity];
            model.user_id = kUserId;
            model.club_id = self.clubId;
            model.news_update_time = [[NSDate date] timeIntervalSince1970];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            
        }];
    }
}

- (void)refreshAlbumUpdatedTime {
    if (self.clubModel.joined) {
        GNClubModuleUpdateModel *model = [GNClubModuleUpdateModel MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %d and club_id == %d",kUserId, self.clubId]];
        if (model) {
            model.album_update_time = [[NSDate date] timeIntervalSince1970];
        }else {
            model = [GNClubModuleUpdateModel MR_createEntity];
            model.user_id = kUserId;
            model.club_id = self.clubId;
            model.album_update_time = [[NSDate date] timeIntervalSince1970];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            
        }];
    }
}

- (void)refreshNoticeUpdatedTime {
    if (self.clubModel.joined) {
        GNClubModuleUpdateModel *model = [GNClubModuleUpdateModel MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %d and club_id == %d",kUserId, self.clubId]];
        if (model) {
            model.notice_update_time = [[NSDate date] timeIntervalSince1970];
        }else {
            model = [GNClubModuleUpdateModel MR_createEntity];
            model.user_id = kUserId;
            model.club_id = self.clubId;
            model.notice_update_time = [[NSDate date] timeIntervalSince1970];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            
        }];
    }
}































@end
