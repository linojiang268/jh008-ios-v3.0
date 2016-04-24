//
//  GNActivityNPS.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityNPS.h"

@interface GNActivityNPS ()



@end

@implementation GNActivityNPS
+ (instancetype)NPSWithKeyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size {
    
    GNActivityNPS *nps;
    if (keyword==nil||[keyword isEqualToString:@""]) {
        
        
        nps = [[GNActivityNPS alloc]initWithURL:@"/api/activity/city/list"
                                     parameters:@{@"city":kNumber(kUserCityID),
                                                  @"page":kNumber(page)}
                                    requestType:GNNetworkRequestTypeNone
                              mappingModelClass:NSClassFromString(@"GNActivityListModel")
                           localCacheIdentifier:@"activity_list"];
    }else{
        nps = [[GNActivityNPS alloc] initWithURL:@"/api/activity/search/name"
                                      parameters:@{@"city":kNumber(kUserCityID),
                                                   @"page":kNumber(page),
                                                   @"keyword":keyword}
                               mappingModelClass:NSClassFromString(@"GNActivityListModel")];
    }
    

    
    return nps;
    
}

@end

@implementation GNActivitySearchNPS
+ (instancetype)NPSWithKeyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size {
    
    GNActivitySearchNPS *nps = [[GNActivitySearchNPS alloc] initWithURL:@"/api/activity/search/name"
                                                requestType:page == 0 ? GNNetworkRequestTypeRequestAfterCache: GNNetworkRequestTypeNone
                                          mappingModelClass:NSClassFromString(@"GNActivityListModel")
                                       localCacheIdentifier:@"activitySearch_list"];
    
    nps.keyword = keyword;
    nps.page = page;
    nps.size = size;
    
    return nps;
    
}

- (void)assemblyParameters {
    
    self.parameters = [NSMutableDictionary dictionary];
    [self.parameters setObject:kNumber(1) forKey:@"city"];
    //    if (self.keyword) {
    //        [self.parameters setObject:self.keyword forKey:@"name"];
    //    }
    [self.parameters setObject:kNumber(self.page) forKey:@"page"];
    [self.parameters setObject:kNumber(self.size) forKey:@"size"];
}
@end


@implementation GNActivityDetailsNPS
+ (instancetype)NPSWithActivityID:(NSString *)activityID{
    
    GNActivityDetailsNPS *nps = [[GNActivityDetailsNPS alloc] initWithURL:@"/api/activity/detail"
                                                               parameters:@{@"activity":activityID}
                                                        mappingModelClass:NSClassFromString(@"GNActivityDetailsModel")];
    

    return nps;
    
}


@end

@implementation GNActivityScoreNPS

+ (instancetype)NPSWithScoreData{
    GNActivityScoreNPS *nps = [[GNActivityScoreNPS alloc] initWithURL:@"/api/activity/no/score"
                               parameters:nil
                               mappingModelClass:NSClassFromString(@"GNActivityScoreModel")];
    return nps;
}

+ (instancetype)NPSWithActivityID:(NSInteger)activityid score:(NSInteger)score attributes:(NSArray *)attributes memo:(NSString *)memo{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"activity":kNumber(activityid),
                                                                                @"score":kNumber(score),
                                                                                }];
    if (memo) {
        [dict setObject:memo forKey:@"memo"];
    }
    
    GNActivityScoreNPS *nps = [[GNActivityScoreNPS alloc]initWithURL:@"/api/activity/member/score"];
    
    [dict setObject:[nps createSign:dict] forKey:@"sign"];
    if (attributes && attributes.count > 0) {
        [dict setObject:attributes forKey:@"attributes"];
    }
    nps.parameters = dict;
    
    return nps;
}

@end

#pragma mark -

@implementation GNActivityApplyNPS

+ (instancetype)NPSWithActivityId:(NSUInteger)activityId info:(NSArray *)info {
    GNActivityApplyNPS *nps = [[GNActivityApplyNPS alloc] initWithURL:@"/api/activity/applicant/applicant"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setObject:kNumber(activityId) forKey:@"activity_id"];
    if (info) {
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (jsonData && !error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            [dict setObject:jsonString forKey:@"attrs"];
        }
    }
    [dict setObject:[nps createSign:dict] forKey:@"sign"];
    
    nps.parameters = dict;
    
    return nps;
    
}

@end


@implementation GNActivityManageAddNewNPS

+ (instancetype)NPSWithActivityID:(NSInteger)activityId attributes:(NSArray *)attributes {
    GNActivityManageAddNewNPS *nps = [[GNActivityManageAddNewNPS alloc] initWithURL:@"/api/manage/act/applicant/vip/add"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setObject:kNumber(activityId) forKey:@"activity"];
    if (attributes) {
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:attributes
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (jsonData && !error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            [dict setObject:jsonString forKey:@"attrs"];
        }
    }

    [dict setObject:[nps createSign:dict] forKey:@"sign"];
    nps.parameters = dict;
    
    
    return nps;
}

@end


