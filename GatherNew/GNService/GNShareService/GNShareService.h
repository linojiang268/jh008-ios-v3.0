//
//  GNShareService.h
//  GatherNew
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@class GNActivityDetails;
@class GNClubDetailModel;
@interface GNShareService : NSObject

+ (void)shareActivity:(GNActivityDetails *)activity;
+ (void)shareClub:(GNClubDetailModel *)club;
+ (void)shareNews:(GNClubDetailModel *)club url:(NSString *)url;
+ (void)shareWithContent:(id<ISSContent>)content;

@end
