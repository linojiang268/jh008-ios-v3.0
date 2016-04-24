//
//  GNActivityManageNPS.h
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"


@interface GNActivityManageListNPS : GNNPSBase

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger size;

+(instancetype)NPSWithPage:(NSUInteger)page size:(NSUInteger)size;


@end




@interface GNActivityManageApplyListNPS : GNNPSBase

//activity	是	数字	活动id
//status	是	数字	报名状态。1 – 待审核；2 – 待支付；3 – 成功报名
//id        否	数字	指定翻页开始的报名id；例如在升序排列的情况下,id = 5，向前翻页，会返回id为2,3,4的记录（假定每页显示3条记录）；向后翻页，返回id为6,7,8的记录
//size      否	数字	每页显示记录数，默认15条
//sort      否	数字	0 – 升序排列；1 – 降序排列；默认为0
//is_pre	否	数字	0 – 向后翻页；1 – 向前翻页；默认为0


@property (nonatomic, assign) NSUInteger activity;
@property (nonatomic, assign) NSUInteger status;
@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, assign) NSUInteger sort;
@property (nonatomic, assign) NSUInteger is_pre;

+(instancetype)NPSWithActivity:(NSUInteger)activity status:(NSUInteger)status size:(NSUInteger)size beginID:(NSInteger)beginID;


@end





@interface GNActivityManageCheckInListNPS : GNNPSBase


@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger size;

+(instancetype)NPSWithActivity:(NSInteger)activity type:(NSInteger)type page:(NSInteger)page size:(NSInteger)size;


@end



@interface GNActivityManageApplyNoteNPS : GNNPSBase


@property (nonatomic, assign) NSUInteger activity;
@property (nonatomic, assign) NSUInteger applicant;
@property (nonatomic, strong) NSString* content;

+(instancetype)NPSWithActivity:(NSInteger)activity applicant:(NSInteger)applicant content:(NSString*)content;


@end



@interface GNActivityManageApplyApproveNPS : GNNPSBase


@property (nonatomic, assign) NSUInteger activity;

+(instancetype)NPSWithActivity:(NSInteger)activity applicantIds:(NSArray*)applicantIds status:(BOOL)approveOrRefuse;


@end


@interface GNActivityManageSendMessageNPS : GNNPSBase


@property (nonatomic, assign) NSUInteger activity;

+(instancetype)NPSWithActivity:(NSInteger)activity content:(NSString*)content;


@end



@interface GNActivityManageGetLeftMessageNPS : GNNPSBase


@property (nonatomic, assign) NSUInteger activity;

+(instancetype)NPSWithActivity:(NSInteger)activity;


@end



@interface GNActivityManageManualCheckInNPS : GNNPSBase

+(instancetype)NPSWithActivity:(NSInteger)activity step:(NSInteger)step userId:(NSInteger)userId approve:(BOOL)approve ;


@end

@interface GNActivityManageQRCodeListNPS : GNNPSBase

+(instancetype)NPSWithActivity:(NSInteger)activity;


@end


@interface GNActivityManageSearchSignInNPS : GNNPSBase

+(instancetype)NPSWithActivity:(NSInteger)activity search:(NSString *)search;


@end

