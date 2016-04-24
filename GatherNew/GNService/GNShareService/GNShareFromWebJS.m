//
//  GNShareFromWebJS.m
//  GatherNew
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNShareFromWebJS.h"
#import "GNShareService.h"
#import <ShareSDK/ShareSDK.h>


@implementation GNShareFromWebJS

-(void)share:(NSString *)title :(NSString *)image :(NSString *)url :(NSString *)content
{
    id<ISSCAttachment> imageImg = [ShareSDK imageWithUrl:image];
    
    //构造分享内容
    id<ISSContent> contentIs = [ShareSDK content:content
                                defaultContent:nil
                                         image:imageImg
                                         title:title
                                           url:url
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeNews];
    
    [contentIs addSinaWeiboUnitWithContent:[title stringByAppendingString:url] image:imageImg];

    [GNShareService shareWithContent:contentIs];
}

@end
