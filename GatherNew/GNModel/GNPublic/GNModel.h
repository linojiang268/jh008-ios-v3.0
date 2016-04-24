//
//  GNModel.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#ifndef GatherNew_GNModel_h
#define GatherNew_GNModel_h

@protocol GNModelCacheProtocol <NSObject>

@required
+ (NSString *)localCacheIdentifier;

@end

typedef NS_ENUM(NSInteger, GNGender) {
    GNGenderMale = 1,
    GNGenderFemale = 2
};

typedef NS_ENUM(NSUInteger, GNClubMemberVisibility) {
    GNClubMemberVisibilityAll       = 0,
    GNClubMemberVisibilityInClub    = 1,
};

#define kGNInvalidCode NSNotFound

#endif
