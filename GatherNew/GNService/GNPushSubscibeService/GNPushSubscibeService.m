//
//  GNPushSubscibeService.m
//  GatherNew
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNPushSubscibeService.h"
#import "YunBaService.h"
#import "GNNetworkService.h"

@implementation GNPushSubscibeService

/// 初始化订阅服务，订阅静态频道
+ (void)initService {
    [YunBaService setupWithAppkey:kYunBaKey];
    [self subscribe:[self baseTopic]];
    [self sync];
}

+ (void)uploadDeviceToken:(NSData *)deviceToken {
    [YunBaService storeDeviceToken:deviceToken resultBlock:^(BOOL succ, NSError *error) {
        if (succ) {
            DDLogInfo(@"store device token to YunBa succ");
        } else {
            DDLogError(@"store device token to YunBa failed due to : %@, recovery suggestion: %@", error, [error localizedRecoverySuggestion]);
        }
    }];
}

+ (NSArray *)baseTopic {
    NSMutableArray *topics = [[NSMutableArray alloc] initWithArray:@[@"topic_static_all",@"topic_static_ios"]];
    if (![GNApp userIsLogin]) {
        [topics addObject:@"topic_static_no_login"];
    }
    if (kUserCityID > 0) {
        [topics addObject:[NSString stringWithFormat:@"topic_static_city_%d",kUserCityID]];
    }
    
    return topics;
}

/// 订阅
+ (void)subscribe:(NSArray *)topics {
    
    for (NSString *topic in topics) {
        [YunBaService subscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                DDLogInfo(@"subscribe to topic succeed");
            } else {
                DDLogError(@"subscribe to topic failed: %@,topic:%@", error,topic);
            }
        }];
    }
    [self subscribeCity:kUserCityID];
}

/// 反订阅
+ (void)unsubscribe:(NSArray *)topics {
    
    for (NSString *topic in topics) {
        [YunBaService unsubscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                DDLogInfo(@"unsubscribe to topic succeed");
            } else {
                DDLogError(@"unsubscribe to topic failed: %@,topic:%@", error,topic);
            }
        }];
    }
    [self unsubscribeCity:kUserCityID];
}

/// 设置别名，用户手机号
+ (void)setAlias:(NSString *)alias {
    [YunBaService setAlias:alias resultBlock:^(BOOL succ, NSError *error) {
        if (succ) {
            DDLogInfo(@"set alias succeed");

            /// 通知服务器可以推送掉线信息
            GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/alias/bound"];
            [GNNetworkService GETWithService:nps success:^(id response, id model) {

            } error:^(id response, NSInteger code) {
                
            } failure:^(id req, NSError *error) {
                
            }];
        } else {
            DDLogError(@"set alias failed");
        }
    }];
}

/// 订阅城市
+ (void)subscribeCity:(NSUInteger)city {
    if (city > 0) {
        NSString *topic = [NSString stringWithFormat:@"topic_static_city_%d",city];
        [YunBaService subscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                DDLogInfo(@"subscribe to topic succeed");
            } else {
                DDLogError(@"subscribe to topic failed: %@,topic:%@", error,topic);
            }
        }];
    }
}

/// 反订阅城市，切换城市时调用
+ (void)unsubscribeCity:(NSUInteger)city {
    if (city > 0) {
        NSString *topic = [NSString stringWithFormat:@"topic_static_city_%d",city];
        [YunBaService unsubscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                DDLogInfo(@"subscribe to topic succeed");
            } else {
                DDLogError(@"subscribe to topic failed: %@,topic:%@", error,topic);
            }
        }];
    }
}

/// 订阅活动，活动报名直接成功时调用（不需要审核）
+ (void)subscribeActivity:(NSUInteger)activity {
    if (activity > 0) {
        NSString *topic = [NSString stringWithFormat:@"topic_activity_%d",activity];
        [YunBaService subscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                DDLogInfo(@"subscribe to topic succeed");
            } else {
                DDLogError(@"subscribe to topic failed: %@,topic:%@", error,topic);
            }
        }];
    }
}

/// 订阅社团，加入社团成功时调用（不需要审核）
+ (void)subscribeClub:(NSUInteger)club {
    if (club > 0) {
        NSString *topic = [NSString stringWithFormat:@"topic_team_%d",club];
        [YunBaService subscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                DDLogInfo(@"subscribe to topic succeed");
            } else {
                DDLogError(@"subscribe to topic failed: %@,topic:%@", error,topic);
            }
        }];
    }
}

/// 同步订阅列表
+ (void)sync {
    if ([GNApp userIsLogin]) {
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/my/topics"];
        [GNNetworkService GETWithService:nps success:^(id response, id model) {
            [self handleDifferent:response];
        } error:^(id response, NSInteger code) {
            DDLogError(@"获取topic列表失败:%@",[response objectForKey:@"message"]);
        } failure:^(id req, NSError *error) {
            DDLogError(@"获取topic列表失败");
        }];

    }else {
        [self unsubscribeUser];
    }
}

+ (void)handleDifferent:(NSDictionary *)subscribeTopics {
    
    if (subscribeTopics.count > 0) {
        if ([[subscribeTopics allKeys] containsObject:@"topic_list"]) {
            NSMutableArray *topics = [[NSMutableArray alloc] initWithArray:[subscribeTopics objectForKey:@"topic_list"]];
            if (topics.count > 0) {
                [YunBaService getTopicList:^(NSArray *res, NSError *error) {
                    if (!error && res && res.count > 0) {
                        NSMutableArray *subscibed = [[NSMutableArray alloc] initWithArray:res];
                        /// 首先删掉公共基础频道
                        [subscibed removeObjectsInArray:[self baseTopic]];
                        
                        /// 已订阅的删掉需要订阅的等于需要取消订阅的
                        [subscibed removeObjectsInArray:topics];
                        [self unsubscribe:subscibed];
                        [self subscribe:topics];
                    }else {
                        [self subscribe:topics];
                    }
                }];
            }
        }
    }
}

/// 反订阅用户相关信息，退出登陆时调用
+ (void)unsubscribeUser {
    [YunBaService getTopicList:^(NSArray *res, NSError *error) {
        if (!error && res && res.count > 0) {
            NSMutableArray *subscibed = [[NSMutableArray alloc] initWithArray:res];
            /// 删掉公共基础频道
            [subscibed removeObjectsInArray:[self baseTopic]];
            [self unsubscribe:subscibed];
        }
    }];
}

/// 反订阅未登陆频道（取消订阅）
+ (void)unsubscribeNotLogin {
    [YunBaService unsubscribe:@"topic_static_no_login" resultBlock:^(BOOL succ, NSError *error) {
        if (succ) {
            DDLogInfo(@"unsubscribe to topic succeed");
        } else {
            DDLogError(@"unsubscribe to topic failed: [topic_static_no_login], error:%@", error);
        }
    }];
}

@end
