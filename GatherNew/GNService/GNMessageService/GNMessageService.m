//
//  GNMessageService.m
//  GatherNew
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMessageService.h"
#import "GNMessageVM.h"

@interface GNMessageService ()

@property (nonatomic, strong) GNMessageVM *clubMessageVM;
@property (nonatomic, strong) GNMessageVM *systemMessageVM;

@property (nonatomic, assign) BOOL haveUpdate;

@property (nonatomic, assign) BOOL clubMessageLoadComplete;
@property (nonatomic, assign) BOOL systemMessageLoadComplete;

@property (nonatomic, copy) void(^block)(BOOL haveUpdate);

@end

@implementation GNMessageService

+ (GNMessageService *)shared {
    static GNMessageService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[GNMessageService alloc] init];
        shared.haveUpdate = NO;
        shared.clubMessageVM = [[GNMessageVM alloc] initWithType:GNMessageTypeClub];
        shared.systemMessageVM = [[GNMessageVM alloc] initWithType:GNMessageTypeSystem];
        
        [shared.clubMessageVM.refreshResponse start:NO success:^(id response, id model) {
            shared.clubMessageLoadComplete = YES;
            [shared checkIsEnd];
        } error:^(id response, NSInteger code) {
            shared.clubMessageLoadComplete = YES;
            [shared checkIsEnd];
        } failure:^(id req, NSError *error) {
            shared.clubMessageLoadComplete = YES;
            [shared checkIsEnd];
        }];
        
        [shared.systemMessageVM.refreshResponse start:NO success:^(id response, id model) {
            shared.systemMessageLoadComplete = YES;
            [shared checkIsEnd];
        } error:^(id response, NSInteger code) {
            shared.systemMessageLoadComplete = YES;
            [shared checkIsEnd];
        } failure:^(id req, NSError *error) {
            shared.systemMessageLoadComplete = YES;
            [shared checkIsEnd];
        }];
    });
    return shared;
}

+ (void)setHaveUpdate:(BOOL)flag {
    [self shared].haveUpdate = flag;
}

+ (BOOL)haveUpdate {
    return [self shared].haveUpdate;
}

- (void)checkIsEnd {
    if (self.clubMessageLoadComplete && self.systemMessageLoadComplete) {
        if (self.block) {
            self.block(self.haveUpdate);
        }
    }
}

+ (void)getLatestMessageWithBlock:(void(^)(BOOL haveUpdate))block {
    [self shared].block = block;
    [[self shared].clubMessageVM.refreshResponse start];
    [[self shared].systemMessageVM.refreshResponse start];
}

@end
