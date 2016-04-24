//
//  GNClubListNPS.m
//  GatherNew
//
//  Created by apple on 15/7/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubModuleNPS.h"

@interface GNClubListNPS ()

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) NSUInteger page;

@end

@implementation GNClubListNPS

+ (instancetype)NPSWithKeyword:(NSString *)keyword page:(NSUInteger)page {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:kNumber(kUserCityID) forKey:@"city"];
    [dict setObject:kNumber(page) forKey:@"page"];
    if (keyword) {
        [dict setObject:keyword forKey:@"name"];
    }
    
    GNNetworkRequestType type = GNNetworkRequestTypeNone;
    /*if (page == kStartPage && !keyword) {
        type = GNNetworkRequestTypeRequestAfterCache;
    }*/
    
    GNClubListNPS *nps = [[GNClubListNPS alloc] initWithURL:@"/api/team/list"
                                                 parameters:dict
                                                requestType:type
                                          mappingModelClass:NSClassFromString(@"GNClubListModel")
                                       localCacheIdentifier:@"club_list"];
    return nps;
    
}


@end

#pragma mark -

@implementation GNClubDetailNPS

+ (instancetype)NPSWithClubId:(NSUInteger)clubId {
    return [[GNClubDetailNPS alloc] initWithURL:@"/api/team/info"
                                     parameters:@{@"team":kNumber(clubId)}
                              mappingModelClass:NSClassFromString(@"GNClubDetailModel")];
}

@end

#pragma mark -

@implementation GNJoinClubNPS

+ (instancetype)NPSWithClubId:(NSUInteger)clubId requirements:(NSDictionary *)requirements {

    GNJoinClubNPS *nps = [[GNJoinClubNPS alloc] initWithURL:@"/api/team/member/enroll"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setObject:kNumber(clubId) forKey:@"team"];
    if ([requirements count]) {
        [dict setObject:[requirements JSONString] forKey:@"requirements"];
    }
    [dict setObject:[nps createSign:dict] forKey:@"sign"];
    
    nps.parameters = dict;
    
    return nps;
}

@end

#pragma mark -

@implementation GNExitClubNPS

+ (instancetype)NPSWithClubId:(NSUInteger)clubId {
    GNExitClubNPS *nps = [[GNExitClubNPS alloc] initWithURL:@"/api/team/member/quit"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setObject:kNumber(clubId) forKey:@"team"];
    [dict setObject:[nps createSign:dict] forKey:@"sign"];
    
    nps.parameters = dict;
    
    return nps;
}

@end

#pragma mark -

@implementation GNClubActivityListNPS

+ (instancetype)NPSWithClubId:(NSUInteger)clubId page:(NSUInteger)page {
    return [[GNClubActivityListNPS alloc] initWithURL:@"/api/activity/team/list"
                                           parameters:@{@"team": kNumber(clubId), @"page": kNumber(page)}
                                    mappingModelClass:NSClassFromString(@"GNActivityListModel")];
}

@end

#pragma mark -

@implementation GNClubNewsNPS

+ (instancetype)NPSWithClubId:(NSUInteger)clubId page:(NSUInteger)page {
    return [[GNClubNewsNPS alloc] initWithURL:@"/api/news"
                                   parameters:@{@"team_id": kNumber(clubId),
                                                @"page": kNumber(page)}
                            mappingModelClass:NSClassFromString(@"GNClubNewsListModel")];

}

@end

#pragma mark -

@implementation GNClubMemberNPS

+ (instancetype)NPSWithClubId:(NSUInteger)clubId page:(NSUInteger)page {
    return [[GNClubMemberNPS alloc] initWithURL:@"/api/team/member/list"
                                     parameters:@{@"team": kNumber(clubId),
                                                  @"page": kNumber(page)}
                              mappingModelClass:NSClassFromString(@"GNMemberListModel")];
    
}

@end

#pragma mark -

@implementation GNClubAlbumNPS

+ (instancetype)NPSWithClubId:(NSUInteger)clubId page:(NSUInteger)page {
    return [[GNClubAlbumNPS alloc] initWithURL:@"/api/activity/hasalbum/list"
                                     parameters:@{@"team": kNumber(clubId),
                                                  @"page": kNumber(page)}
                              mappingModelClass:NSClassFromString(@"GNClubAlbumListModel")];
    
}

@end

#pragma mark -

@implementation GNClubUpdatePrivacyNPS

+ (instancetype)NPSWithClubId:(NSUInteger)clubId visibility:(GNClubMemberVisibility)visibility {
    GNClubUpdatePrivacyNPS *nps = [[GNClubUpdatePrivacyNPS alloc] initWithURL:@"/api/team/member/update"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setObject:kNumber(clubId) forKey:@"team"];
    [dict setObject:kNumber(visibility) forKey:@"visibility"];
    [dict setObject:[nps createSign:dict] forKey:@"sign"];
    
    nps.parameters = dict;
    
    return nps;
}

@end






