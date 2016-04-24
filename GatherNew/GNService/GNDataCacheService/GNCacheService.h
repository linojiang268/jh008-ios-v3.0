//
//  GNCacheService.h
//  GatherNew
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GNModel.h"

@interface GNCacheService : NSObject

+ (void)initService;
+ (void)uninstallService;

+ (void)cacheWithDataString:(NSString *)dataString
       localCacheIdentifier:(NSString *)localCacheIdentifier;

+ (void)modelWithClass:(Class<GNModelCacheProtocol>)aClass
               success:(GNSuccessHandler)success
                 error:(GNErrorHandler)error;

+ (void)dataWithIdentifier:(NSString *)identifier
                   success:(GNSuccessHandler)success
                     error:(GNErrorHandler)error;

+ (void)modelWithIdentifier:(NSString *)identifier
                 modelClass:(Class)modelClass
                    success:(GNSuccessHandler)success
                      error:(GNErrorHandler)error;

@end
