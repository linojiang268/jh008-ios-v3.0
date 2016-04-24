//
//  GNNetworkService.h
//  GatherNew
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"
#import "GNCacheService.h"

typedef NS_ENUM(NSInteger, GNNetworkRequestResultStatusCode) {
    GNNetworkRequestResultStatusCodeSuccess                 = 0,
    GNNetworkRequestResultStatusCodeMappingFailure          = 1,
    GNNetworkRequestResultStatusCodeResponseIsNil           = 2,
    GNNetworkRequestResultStatusCodeInvalidJsonResponse     = 3,
    GNNetworkRequestResultStatusCodeOtherFailure            = 10000,
    GNNetworkRequestResultStatusCodePhoneRegisterFailure    = 10001,
    GNNetworkRequestResultStatusCodeSignFailure             = 10002,
    GNNetworkRequestResultStatusCodeNoLogin                 = 10101,
    GNNetworkRequestResultStatusCodeNoUserInfo              = 10102,
    GNNetworkRequestResultStatusCodeOtherDeviceLogin        = 10103
};

@interface GNNetworkService : NSObject

+ (BOOL)isConnectToNet;

+ (void)GETWithService:(id<GNNetworkParameterServiceProtocol>)service
            success:(GNSuccessHandler)success
              error:(GNErrorHandler)error
            failure:(GNFailureHandler)failure;

+ (void)POSTWithService:(id<GNNetworkParameterServiceProtocol>)service
             success:(GNSuccessHandler)success
               error:(GNErrorHandler)error
             failure:(GNFailureHandler)failure;

@end
