//
//  GNActivityManageNPS.m
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManageNPS.h"



@implementation GNActivityManageListNPS


+(instancetype)NPSWithPage:(NSUInteger)page size:(NSUInteger)size {
    GNActivityManageListNPS * nps = [[GNActivityManageListNPS alloc]initWithURL:@"/api/manage/act/list" parameters:@{@"page":kNumber(page),
                     @"size":kNumber(size)
                    }
        requestType:GNNetworkRequestTypeNone
        mappingModelClass:NSClassFromString(@"GNActivityManageListModel")
        localCacheIdentifier:@"activity_manage_list"];
    
    return nps;
}

@end


@implementation GNActivityManageApplyListNPS

+(instancetype)NPSWithActivity:(NSUInteger)activity status:(NSUInteger)status size:(NSUInteger)size beginID:(NSInteger)beginID {
    GNActivityManageApplyListNPS *nps = [[GNActivityManageApplyListNPS alloc]initWithURL:@"/api/manage/act/applicant/list" parameters:@{
                              @"activity":kNumber(activity),
                              @"status":kNumber(status),
                              @"size":kNumber(size),
                              @"id":kNumber(beginID),
                              @"sort":kNumber(0),
                              @"is_pre":kNumber(0)
                            }
                            requestType:GNNetworkRequestTypeNone
                            mappingModelClass:NSClassFromString(@"GNActivityApplyListModel")
                            localCacheIdentifier:[NSString stringWithFormat:@"activity_apply_list_%ld_%ld", (long)activity, (long)status]];
    return nps;
}

@end


@implementation GNActivityManageCheckInListNPS


+(instancetype)NPSWithActivity:(NSInteger)activity type:(NSInteger)type page:(NSInteger)page size:(NSInteger)size{
    GNActivityManageCheckInListNPS * nps = [[GNActivityManageCheckInListNPS alloc]initWithURL:@"/api/manage/act/checkin/list" parameters:@{
                     @"activity":kNumber(activity),
                     @"page":kNumber(page),
                     @"size":kNumber(size),
                     @"type":kNumber(type)
                   }
                   requestType:GNNetworkRequestTypeNone
                   mappingModelClass:NSClassFromString(@"GNActivityCheckInListModel")
                   localCacheIdentifier:@"activity_manage_check_in_list"];
    
    return nps;
}

@end


@implementation GNActivityManageApplyNoteNPS

+(instancetype)NPSWithActivity:(NSInteger)activity applicant:(NSInteger)applicant content:(NSString *)content{
    GNActivityManageApplyNoteNPS * nps = [[GNActivityManageApplyNoteNPS alloc]initWithURL:@"/api/manage/act/applicant/remark" parameters:@{
                                        @"activity":kNumber(activity),
                                        @"applicant":kNumber(applicant),
                                        @"content":content
                                 }
                            requestType:GNNetworkRequestTypeNone
                            mappingModelClass:nil
                            localCacheIdentifier:@"activity_manage_apply_note"];
    
    return nps;
}

@end



@implementation GNActivityManageApplyApproveNPS

+(instancetype)NPSWithActivity:(NSInteger)activity applicantIds:(NSArray*)applicantIds status:(BOOL)approveOrRefuse {
    GNActivityManageApplyApproveNPS * nps = [[GNActivityManageApplyApproveNPS alloc]
                                   initWithURL:approveOrRefuse?@"/api/manage/act/applicant/approve":@"/api/manage/act/applicant/refuse"
                                    parameters:@{
                                                @"activity":kNumber(activity),
                                                @"applicants":applicantIds,
                                              }
                                   requestType:GNNetworkRequestTypeNone
                             mappingModelClass:nil
                          localCacheIdentifier:@"activity_manage_apply_approve"];
    
    return nps;
}

@end


@implementation GNActivityManageSendMessageNPS

+(instancetype)NPSWithActivity:(NSInteger)activity content:(NSString*)content {
    GNActivityManageSendMessageNPS * nps = [[GNActivityManageSendMessageNPS alloc]
                                             initWithURL:@"/api/manage/act/notice/send"
                                             parameters:@{
                                                          @"activity":kNumber(activity),
                                                          @"content":content,
                                                          }
                                             requestType:GNNetworkRequestTypeNone
                                             mappingModelClass:nil
                                             localCacheIdentifier:@"activity_manage_send_message"];
    
    return nps;
}

@end



@implementation GNActivityManageGetLeftMessageNPS

+(instancetype)NPSWithActivity:(NSInteger)activity {
    GNActivityManageGetLeftMessageNPS * nps = [[GNActivityManageGetLeftMessageNPS alloc]
                                            initWithURL:@"/api/manage/act/notice/send/times"
                                            parameters:@{
                                                         @"activity":kNumber(activity),
                                                         }
                                            requestType:GNNetworkRequestTypeNone
                                            mappingModelClass:nil
                                            localCacheIdentifier:@"activity_manage_left_message"];
    
    return nps;
}

@end



@implementation GNActivityManageManualCheckInNPS

+(instancetype)NPSWithActivity:(NSInteger)activity step:(NSInteger)step userId:(NSInteger)userId approve:(BOOL)approve {
    GNActivityManageManualCheckInNPS * nps = [[GNActivityManageManualCheckInNPS alloc]
                                               initWithURL:approve?@"/api/manage/act/checkin":@"/api/manage/act/remove/checkin"
                                               parameters:@{
                                                            @"activity_id":kNumber(activity),
                                                            @"step":kNumber(step),
                                                            @"user":kNumber(userId),
                                                            }
                                               requestType:GNNetworkRequestTypeNone
                                               mappingModelClass:nil
                                               localCacheIdentifier:@"activity_manage_manual_check_in"];
    
    return nps;
}

@end



@implementation GNActivityManageQRCodeListNPS

+(instancetype)NPSWithActivity:(NSInteger)activity {
    GNActivityManageQRCodeListNPS * nps = [[GNActivityManageQRCodeListNPS alloc]
                                              initWithURL:@"api/manage/act/checkin/qrcode/list"
                                              parameters:@{
                                                           @"activity_id":kNumber(activity),
                                                           }
                                              requestType:GNNetworkRequestTypeNone
                                              mappingModelClass:nil
                                              localCacheIdentifier:@"activity_manage_qr_code_list"];
    
    return nps;
}

@end

@implementation GNActivityManageSearchSignInNPS

+(instancetype)NPSWithActivity:(NSInteger)activity search:(NSString *)search {
    GNActivityManageSearchSignInNPS * nps = [[GNActivityManageSearchSignInNPS alloc]
                                           initWithURL:@"api/manage/act/checkin/search"
                                           parameters:@{
                                                        @"activity":kNumber(activity),
                                                        @"search":search,
                                                        }
                                           requestType:GNNetworkRequestTypeNone
                                           mappingModelClass:NSClassFromString(@"GNActivityCheckInListModel")
                                           localCacheIdentifier:@"activity_manage_search_sign_in"];
    
    return nps;
}

@end
