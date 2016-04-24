//
//  GNCacheService.m
//  GatherNew
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNCacheService.h"
#import <MJExtension.h>
#import "GNDataCacheModel.h"
#import "NSString+GNExtension.h"
#import <CoreData+MagicalRecord.h>

@implementation GNCacheService

+ (void)initService {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Gather.sqlite"];
}

+ (void)uninstallService {
    [MagicalRecord cleanUp];
}

+ (void)cacheWithDataString:(NSString *)dataString localCacheIdentifier:(NSString *)localCacheIdentifier {
    if (![NSString isBlank:localCacheIdentifier]) {
        GNDataCacheModel *model = [GNDataCacheModel MR_findFirstByAttribute:@"identifier" withValue:localCacheIdentifier];
        if (model) {
            model.content = dataString;
        }else {
            model = [GNDataCacheModel MR_createEntity];
            model.identifier = localCacheIdentifier;
            model.content = dataString;
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (error) {
                DDLogError(@"\nCache error localCacheIdentifier: %@ \nResponse:%@\nError: %@",localCacheIdentifier,dataString,error);
            }
        }];
    }else {
        DDLogError(@"localCacheIdentifier is nil");
    }

}

+ (void)getCacheFromIdentifier:(NSString *)identifier
                    modelClass:(Class)modelClass
                       success:(GNSuccessHandler)success
                         error:(GNErrorHandler)error
{
    NSString *queryIdentifier = identifier;
    
    if ([NSString isBlank:queryIdentifier]) {
        @try {
            queryIdentifier = [modelClass localCacheIdentifier];
        }
        @catch (NSException *exception) {
            DDLogError(@"get cache error, because identifier is nil and modelClass don't implemented GNModelCacheProtocol");
            return;
        }
    }
    
    if (![NSString isBlank:queryIdentifier]) {
        GNDataCacheModel *model = [GNDataCacheModel MR_findFirstByAttribute:@"identifier" withValue:queryIdentifier];
        if (model && model.content.length > 0) {
            if (modelClass) {
                NSError *e;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[model.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
                if (!e && dict) {
                    id model = [modelClass objectWithKeyValues:dict error:&e];
                    if (!e && model) {
                        success(dict, model);
                    }else {
                        DDLogError(@"\nMapping failure identifier %@ \nResponse:%@",identifier,dict);
                        error(dict, 1);
                    }
                }
            }else {
                success(model.content, nil);
            }
        }else {
            DDLogError(@"Don't find the content of the identifier as %@",identifier);
        }
    }else {
        DDLogError(@"identifier is nil");
    }
}

+ (void)modelWithClass:(Class<GNModelCacheProtocol>)aClass
               success:(GNSuccessHandler)success
                 error:(GNErrorHandler)error
{
    [self getCacheFromIdentifier:nil modelClass:aClass success:success error:error];
}

+ (void)dataWithIdentifier:(NSString *)identifier
                    success:(GNSuccessHandler)success
                      error:(GNErrorHandler)error
{
    
    [self getCacheFromIdentifier:identifier modelClass:NULL success:success error:error];
}

+ (void)modelWithIdentifier:(NSString *)identifier
                 modelClass:(Class)modelClass
                    success:(GNSuccessHandler)success
                      error:(GNErrorHandler)error
{
    [self getCacheFromIdentifier:identifier modelClass:modelClass success:success error:error];
}

@end
