//
//  GNShareService.m
//  GatherNew
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNShareService.h"
#import <ShareSDK/ShareSDK.h>
#import "GNNetworkService.h"
#import "GNActivityDetailsModel.h"
#import "GNClubListModel.h"

@implementation GNShareService


+ (void)shareActivity:(GNActivityDetails *)activity {
    if (activity) {
        NSString *url = [NSString stringWithFormat:@"%@/wap/activity/detail?activity_id=%ld", kHttpDomain, (long)activity.id];
        
        id<ISSCAttachment> image = [ShareSDK imageWithUrl:[activity.images_url firstObject]];
        
        DateTime begin = {0};
        ParseDateTime([activity.begin_time UTF8String], begin);
        DateTime end = {0};
        ParseDateTime([activity.end_time UTF8String], end);
        NSMutableString* time = [[NSMutableString alloc] initWithString:activity.title];
        if (begin.year == end.year && begin.mon == end.mon && begin.day == end.day) {
            [time appendFormat:@"\n活动时间：%ld月%ld日 %02ld:%02ld-%02ld:%02ld",
                begin.mon,begin.day,begin.hour,begin.min,end.hour,end.min];
        }else {
            [time appendFormat:@"\n活动时间：%ld月%ld日 %02ld:%02ld-%ld月%ld日 %02ld:%02ld",
                begin.mon,begin.day,begin.hour,begin.min,end.mon,end.day,end.hour,end.min];
        }
        
        //构造分享内容
        id<ISSContent> content = [ShareSDK content:time
                                    defaultContent:nil
                                             image:image
                                             title:activity.title
                                                url:url
                                        description:nil
                                          mediaType:SSPublishContentMediaTypeNews];
        [content addSinaWeiboUnitWithContent:[activity.title stringByAppendingString:url] image:image];
        [self shareWithContent:content];
    }
}

+ (void)shareClub:(GNClubDetailModel *)club {
    if (club) {
        NSString *url = [NSString stringWithFormat:@"%@/wap/team/detail?team_id=%ld",kHttpDomain, (long)club.id];
        
        id<ISSCAttachment> image = [ShareSDK imageWithUrl:club.logo_url];
        
        //构造分享内容
        id<ISSContent> content = [ShareSDK content:club.introduction
                                    defaultContent:nil
                                             image:image
                                             title:club.name
                                               url:url
                                       description:nil
                                         mediaType:SSPublishContentMediaTypeNews];
        [content addSinaWeiboUnitWithContent:[club.name stringByAppendingString:url] image:image];
        [self shareWithContent:content];
    }
}

+ (void)shareNews:(GNClubDetailModel *)club url:(NSString *)url {
    if (club && url) {
        id<ISSCAttachment> image = [ShareSDK imageWithUrl:club.logo_url];
        
        //构造分享内容
        id<ISSContent> content = [ShareSDK content:club.introduction
                                    defaultContent:nil
                                             image:image
                                             title:club.name
                                               url:url
                                       description:nil
                                         mediaType:SSPublishContentMediaTypeNews];
        [content addSinaWeiboUnitWithContent:[club.name stringByAppendingString:url] image:image];
        [self shareWithContent:content];
    }
}

+ (void)shareWithContent:(id<ISSContent>)content
{
    /**
     *	@brief	创建分享内容对象，根据以下每个字段适用平台说明来填充参数值
     *
     *	@param 	content 	分享内容（新浪、腾讯、微信、QQ）
     *	@param 	defaultContent 	默认分享内容（新浪、腾讯、微信、QQ）
     *	@param 	image 	分享图片（新浪、腾讯、微信、QQ）
     *	@param 	title 	标题（QQ空间、人人、微信、QQ）
     *	@param 	url 	链接（QQ空间、微信、QQ）
     *	@param 	mediaType 	分享类型（QQ、微信）
     *
     *	@return	分享内容对象
     */
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:content
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                                if (state == SSResponseStateSuccess) {
                                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                }else if (state == SSResponseStateFail) {
                                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                    DDLogError(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}

@end
