//
//  GNClubListNPS.h
//  GatherNew
//
//  Created by apple on 15/7/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"

#pragma mark -

@interface GNClubListNPS : GNNPSBase

+ (instancetype)NPSWithKeyword:(NSString *)keyword page:(NSUInteger)page;

@end

#pragma mark -

@interface GNClubDetailNPS : GNNPSBase

+ (instancetype)NPSWithClubId:(NSUInteger)clubId;

@end

#pragma mark -

@interface GNJoinClubNPS : GNNPSBase

+ (instancetype)NPSWithClubId:(NSUInteger)clubId requirements:(NSDictionary *)requirements;

@end

#pragma mark -

@interface GNExitClubNPS : GNNPSBase

+ (instancetype)NPSWithClubId:(NSUInteger)clubId;

@end

#pragma mark -

@interface GNClubActivityListNPS : GNNPSBase

+ (instancetype)NPSWithClubId:(NSUInteger)clubId page:(NSUInteger)page;

@end

#pragma mark -

@interface GNClubNewsNPS : GNNPSBase

+ (instancetype)NPSWithClubId:(NSUInteger)clubId page:(NSUInteger)page;

@end

#pragma mark -

@interface GNClubMemberNPS : GNNPSBase

+ (instancetype)NPSWithClubId:(NSUInteger)clubId page:(NSUInteger)page;

@end

#pragma mark -

@interface GNClubAlbumNPS : GNNPSBase

+ (instancetype)NPSWithClubId:(NSUInteger)clubId page:(NSUInteger)page;

@end

#pragma mark -

@interface GNClubUpdatePrivacyNPS : GNNPSBase

+ (instancetype)NPSWithClubId:(NSUInteger)clubId visibility:(GNClubMemberVisibility)visibility;

@end