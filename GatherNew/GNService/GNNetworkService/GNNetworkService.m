//
//  GNNetworkService.m
//  GatherNew
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//


#import "GNNetworkService.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface GNNetworkService ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;

@end

@implementation GNNetworkService

+ (GNNetworkService *)service {
    static dispatch_once_t onceToken;
    static GNNetworkService *service;
    dispatch_once(&onceToken, ^{
        service = [[GNNetworkService alloc] init];
    });
    
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kHttpDomain]];
        
        [self.httpManager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [self monitorNetworkState];
    }
    return self;
}

- (void)monitorNetworkState {
    
    NSOperationQueue *queue = self.httpManager.operationQueue;
    [self.httpManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [queue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [queue setSuspended:YES];
                [SVProgressHUD showErrorWithStatus:@"网络连接中断，请检查网络!"];
                break;
            case AFNetworkReachabilityStatusUnknown:
                
                break;
            default:
                break;
        }
    }];
    [self.httpManager.reachabilityManager startMonitoring];
}

+ (BOOL)isConnectToNet {
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

+ (void)handleResponseWithService:(id<GNNetworkParameterServiceProtocol>)service
                       response:(NSDictionary *)response
                        success:(GNSuccessHandler)success
                          error:(GNErrorHandler)error
{
    if (response) {
        if ([NSJSONSerialization isValidJSONObject:response]) {
            NSInteger resultCode = [[response objectForKey:@"code"] integerValue];
            if (resultCode == GNNetworkRequestResultStatusCodeSuccess) {
                if ([service mappingModelClass]) {
                    [[self class] mappingModelWithResponse:response service:service success:success error:error];
                }else {
                    success(response, nil);
                }
                switch ([service requestType]) {
                    case GNNetworkRequestTypeRequestAfterCache:
                    case GNNetworkRequestTypeGetCacheAfterRefreshAndCache:
                    {
                        NSError *e;
                        NSData *data = [NSJSONSerialization dataWithJSONObject:response options:0 error:&e];
                        if (!e && data) {
                            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            [GNCacheService cacheWithDataString:jsonString localCacheIdentifier:[service localCacheIdentifier]];
                        }else {
                            DDLogError(@"When cache conversion failure %@\n",e);
                        }
                    }
                        break;
                    default:
                        break;
                }
            }else if(resultCode == GNNetworkRequestResultStatusCodeNoLogin) {
                if (!kApp.lostConnectionAlert.visible) {
                    if ([kApp.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                        [kApp showLoginUI];
                    }
                }
            }else if(resultCode == GNNetworkRequestResultStatusCodeOtherDeviceLogin) {
                [kApp showLostConnectionAlertView];
            }else {
                DDLogError(@"\nRequest url: %@ message:%@ code:%ld\nParameters:%@",[service url],
                           [response objectForKey:@"message"],(long)resultCode,[service parameters]);
                error(response, resultCode);
            }
        }else {
            DDLogError(@"\nInvalid json Request url: %@ \nParameters:%@",[service url],[service parameters]);
            error(response, GNNetworkRequestResultStatusCodeInvalidJsonResponse);
        }
    }else {
        DDLogError(@"\nResponse error is nil Request url: %@ \nParameters:%@",[service url],[service parameters]);
        error(response, GNNetworkRequestResultStatusCodeResponseIsNil);
    }
}

+ (void)mappingModelWithResponse:(NSDictionary *)dict
                         service:(id<GNNetworkParameterServiceProtocol>)service
                         success:(GNSuccessHandler)success
                           error:(GNErrorHandler)error
{
    NSError *e;
    id model = [[service mappingModelClass] objectWithKeyValues:dict error:&e];
    if (!e && model) {
        success(dict, model);
    }else {
        DDLogError(@"\nMapping failure Request url: %@ \nResponse:%@",[service url],dict);
        error(dict, GNNetworkRequestResultStatusCodeMappingFailure);
    }
}

/*+ (void)cacheModelWithResponse:(NSDictionary *)dict
                       service:(id<GNNetworkParameterServiceProtocol>)service
{
    if (![[service localCacheIdentifier] isBlank]) {
        GNDataCacheModel *model = [GNDataCacheModel MR_findFirstByAttribute:@"identifier" withValue:[service localCacheIdentifier]];
        NSError *e;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&e];
        if (!e && data) {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (model) {
                model.content = jsonString;
            }else {
                model = [GNDataCacheModel MR_createEntity];
                model.identifier = [service localCacheIdentifier];
                model.content = jsonString;
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                if (error) {
                    DDLogError(@"\nCache error StoreIdentifier: %@ \nResponse:%@\nError: %@",[service localCacheIdentifier],dict,error);
                }
            }];
        }else {
            DDLogError(@"When cache conversion failure %@\n",e);
        }
    }else {
        DDLogError(@"Get type is need cache but service storeIdentifier is nil,error from class: %@",NSStringFromClass([service class]));
    }
}

+ (void)getCacheWithService:(id<GNNetworkParameterServiceProtocol>)service
                    success:(GNSuccessHandler)success
                      error:(GNErrorHandler)error
{
    if ([service mappingModelClass] && ![[service localCacheIdentifier] isBlank]) {
        GNDataCacheModel *model = [GNDataCacheModel MR_findFirstByAttribute:@"identifier" withValue:[service localCacheIdentifier]];
        if (model && model.content.length > 0) {
            
            NSError *e;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[model.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
            
            if (!e && dict) {
                [[self class] mappingModelWithResponse:dict service:service success:success error:error];
            }else {
                DDLogError(@"Get cache parser failure %@ \nCache content: %@\nMappingModelClass: %@",error,dict,[service mappingModelClass]);
            }
        }
    }else {
        DDLogError(@"Get type is need get cache but modelClass or cacheIdentifier is nil,error from class: %@",NSStringFromClass([service class]));
    }
}*/

+ (void)GETWithService:(id<GNNetworkParameterServiceProtocol>)service
            success:(GNSuccessHandler)success
              error:(GNErrorHandler)error
            failure:(GNFailureHandler)failure
{
    [service assemblyParameters];
    
    if ([service requestType] == GNNetworkRequestTypeGetCacheAfterRefreshAndCache) {
        [GNCacheService modelWithIdentifier:[service localCacheIdentifier] modelClass:[service mappingModelClass] success:success error:error];
    }
    
    [[self service].httpManager GET:[service url]
                         parameters:[service parameters]
                            success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"Request url: %@ \n\nResponse: %@\n\n%@\n\nFormat:%@\n",[service url],[responseObject objectForKey:@"message"],operation.responseString,responseObject);
        [[self class] handleResponseWithService:service response:responseObject success:success error:error];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"Request failure url: %@ \nparameters:%@\nerror:\n\n%@",[service url], [service parameters], error);
        failure(operation, error);
    }];
}


+ (void)POSTWithService:(id<GNNetworkParameterServiceProtocol>)service
             success:(GNSuccessHandler)success
               error:(GNErrorHandler)error
             failure:(GNFailureHandler)failure
{
    [service assemblyParameters];
    
    if ([service requestType] == GNNetworkRequestTypeGetCacheAfterRefreshAndCache) {
        [GNCacheService modelWithIdentifier:[service localCacheIdentifier] modelClass:[service mappingModelClass] success:success error:error];
    }
    
    [[self service].httpManager POST:[service url]
                          parameters:[service parameters]
           constructingBodyWithBlock:[service formData]
                             success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"Request url: %@ \n\nResponse: %@\n\n%@\n\nFormat:%@\n",[service url],[responseObject objectForKey:@"message"],operation.responseString,responseObject);
        [[self class] handleResponseWithService:service response:responseObject success:success error:error];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"Request failure url: %@ \nparameters:%@\nerror:\n\n%@",[service url], [service parameters], error);
        failure(operation, error);
    }];
}

@end
























