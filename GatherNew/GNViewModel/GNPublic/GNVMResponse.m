//
//  GNVMResponse.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMResponse.h"

@interface GNVMResponse ()

@property (nonatomic, copy) void(^taskBlock)(void);

@end

@implementation GNVMResponse

- (void)dealloc {
    DDLogError(@"dealloc %@",NSStringFromClass([self class]));
}

+ (instancetype)responseWithTaskBlock:(void(^)(void))block {
    GNVMResponse *response = [[GNVMResponse alloc] init];
    response.taskBlock = block;
    return response;
}

- (void)start {
    if (self.taskBlock) {
        NSAssert(self.success, @"success block can't be nil");
        NSAssert(self.error, @"error block can't be nil");
        NSAssert(self.failure, @"failure block can't be nil");
        
        self.taskBlock();
    }
}

- (void)start:(BOOL)start
      success:(GNSuccessHandler)success
        error:(GNErrorHandler)error
      failure:(GNFailureHandler)failure;
{
    self.success = success;
    self.error = error;
    self.failure = failure;
    
    if (start) {
        [self start];
    }
}

@end
