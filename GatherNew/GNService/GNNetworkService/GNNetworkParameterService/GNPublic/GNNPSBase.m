//
//  GNNPSBase.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNNPSBase.h"
#import "NSString+GNExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#if APP_ENVIRONMENT == APP_ENVIRONMENT_TEST
    #define kSignKey @"F1C86DC81A8CBCE4EEB9D219B68D6E66"
#else
    #define kSignKey @"RDPTQSUB1AKR7LO9Y17BTK2YC0PBAJ0L"
#endif

@implementation GNNPSBase

- (instancetype)init
{
    return  [self initWithURL:nil];
}

- (instancetype)initWithURL:(NSString *)url
{
    return [self initWithURL:url parameters:nil];
}

- (instancetype)initWithURL:(NSString *)url
                 parameters:(NSDictionary *)parameters
{
    return [self initWithURL:url parameters:parameters mappingModelClass:NULL];
}

- (instancetype)initWithURL:(NSString *)url
                 parameters:(NSDictionary *)parameters
          mappingModelClass:(Class)mappingModelClass
{
     return [self initWithURL:url parameters:parameters requestType:GNNetworkRequestTypeNone mappingModelClass:mappingModelClass localCacheIdentifier:nil];
}

- (instancetype)initWithURL:(NSString *)url
                requestType:(GNNetworkRequestType)requestType
          mappingModelClass:(Class)mappingModelClass
       localCacheIdentifier:(NSString *)localCacheIdentifier
{
    return [self initWithURL:url parameters:nil requestType:requestType mappingModelClass:mappingModelClass localCacheIdentifier:localCacheIdentifier];
}

- (instancetype)initWithURL:(NSString *)url
                 parameters:(NSDictionary *)parameters
                requestType:(GNNetworkRequestType)requestType
          mappingModelClass:(Class)mappingModelClass
       localCacheIdentifier:(NSString *)localCacheIdentifier
{
    self = [super init];
    if (self) {
        self.url = url;
        self.parameters = parameters;
        self.requestType = requestType;
        self.localCacheIdentifier = localCacheIdentifier;
        self.mappingModelClass = mappingModelClass;
    }
    return self;
}

- (void)assemblyParameters {
    
}

- (NSString*)encodeURL:(NSString *)string {
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[string UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(NSString *)createSign:(NSDictionary *)dic{
    NSArray *array =[dic allKeys];
    NSArray *kays = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *resultStr = [NSMutableString string];
    NSString *signKey = [NSString stringWithFormat:@"key=%@",kSignKey];
    [resultStr appendString:signKey];
    for (NSString *key in kays) {
        
        [resultStr appendString:@"&"];
        
        id value = dic[key];
        if ([value isKindOfClass:[NSNumber class]]) {
            [resultStr appendString:[NSString stringWithFormat:@"%@=%@",key,[self encodeURL:[value stringValue]]]];
        }else {
            if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSMutableArray class]]){
                DDLogInfo(@"%@ is a array, skip sign", key);
                continue;
            }
            [resultStr appendString:[NSString stringWithFormat:@"%@=%@",key,[self encodeURL:value]]];
        }
    }
    
    return [self sha512:resultStr];
}

- (NSString *)sha512:(NSString *)param
{
    const char *cstr = [param cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:param.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
