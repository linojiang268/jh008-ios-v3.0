//
//  GNNPSBase.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFURLRequestSerialization.h>

typedef NS_ENUM(NSUInteger, GNNetworkRequestType) {
    GNNetworkRequestTypeNone                            = 1,
    GNNetworkRequestTypeRequestAfterCache               = 2,
    GNNetworkRequestTypeGetCacheAfterRefreshAndCache    = 3,
};

#define kDefaultSize 10
#define kStartPage 1

@protocol GNNetworkParameterServiceProtocol <NSObject>

@required
@property (nonatomic, strong) NSString *url;

@optional
@property (nonatomic, strong) id parameters; // NSDictionary
@property (nonatomic, strong) Class mappingModelClass;
@property (nonatomic, strong) NSString *localCacheIdentifier;
@property (nonatomic, assign) GNNetworkRequestType requestType;
@property (nonatomic, copy) void(^formData)(id<AFMultipartFormData> formData);

- (void)assemblyParameters;

@end

@interface GNNPSBase : NSObject<GNNetworkParameterServiceProtocol> {
    @protected
    NSString *_url;
    id _parameters;
    NSString *_storeIdentifier;
    __strong Class _mappingModelClass;
    GNNetworkRequestType _requestType;
    void(^_formData)(id<AFMultipartFormData> formData);
}

- (instancetype)initWithURL:(NSString *)url;

- (instancetype)initWithURL:(NSString *)url
                 parameters:(NSDictionary *)parameters;

- (instancetype)initWithURL:(NSString *)url
                 parameters:(NSDictionary *)parameters
          mappingModelClass:(Class)mappingModelClass;

- (instancetype)initWithURL:(NSString *)url
                requestType:(GNNetworkRequestType)requestType
          mappingModelClass:(Class)mappingModelClass
       localCacheIdentifier:(NSString *)localCacheIdentifier;

- (instancetype)initWithURL:(NSString *)url
                 parameters:(NSDictionary *)parameters
                requestType:(GNNetworkRequestType)requestType
          mappingModelClass:(Class)mappingModelClass
       localCacheIdentifier:(NSString *)localCacheIdentifier;


@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) id parameters;
@property (nonatomic, strong) Class mappingModelClass;
@property (nonatomic, strong) NSString *localCacheIdentifier;
@property (nonatomic, assign) GNNetworkRequestType requestType;
@property (nonatomic, copy) void(^formData)(id<AFMultipartFormData> formData);

- (void)assemblyParameters;

- (NSString *)createSign:(NSDictionary *)dic;

@end
