//
//  GNVMResponse.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNVMResponse : NSObject

@property (nonatomic, copy) GNSuccessHandler success;
@property (nonatomic, copy) GNErrorHandler error;
@property (nonatomic, copy) GNFailureHandler failure;

+ (instancetype)responseWithTaskBlock:(void(^)(void))block;

- (void)start;

- (void)start:(BOOL)start
      success:(GNSuccessHandler)success
        error:(GNErrorHandler)error
      failure:(GNFailureHandler)failure;

@end
