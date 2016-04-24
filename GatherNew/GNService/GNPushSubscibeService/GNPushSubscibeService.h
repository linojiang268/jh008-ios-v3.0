//
//  GNPushSubscibeService.h
//  GatherNew
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNPushSubscibeService : NSObject

/// 初始化订阅服务，订阅静态频道
+ (void)initService;

/// 上传device token
+ (void)uploadDeviceToken:(NSData *)deviceToken;

/// 设置别名，用户手机号，登陆成功后调用
+ (void)setAlias:(NSString *)alias;

/// 同步订阅列表，应用启动时调用
+ (void)sync;

/// 订阅城市，切换城市时调用
+ (void)subscribeCity:(NSUInteger)city;

/// 反订阅城市，切换城市时调用
+ (void)unsubscribeCity:(NSUInteger)city;

/// 订阅活动，活动报名直接成功时调用（不需要审核）
+ (void)subscribeActivity:(NSUInteger)activity;

/// 订阅社团，加入社团成功时调用（不需要审核）
+ (void)subscribeClub:(NSUInteger)club;

/// 反订阅用户相关信息，退出登陆时调用
+ (void)unsubscribeUser;

/// 反订阅未登陆频道（取消订阅），登陆时调用
+ (void)unsubscribeNotLogin;

@end
