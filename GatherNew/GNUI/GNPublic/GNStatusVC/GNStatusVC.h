//
//  GNStatusVC.h
//  GatherNew
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"

typedef NS_ENUM(NSUInteger, GNStatusType) {
    GNStatusTypeClubJoinOK                    = 1,
    GNStatusTypeClubJoinVerify                = 2,
    GNStatusTypeSignUpForActiveWaiting        = 5,
    GNStatusTypeSignUpForActiveSuccess        = 6,
    GNStatusTypeSignUpForActivePayFailed      = 7
};

@interface GNStatusVC : GNVCBase

+ (instancetype)statusWithStatus:(GNStatusType)status
                     backEnabled:(BOOL)enabled
                     needPayment:(BOOL)payment
                   backEventHandler:(void(^)(GNStatusVC *statusVC))handler;

+ (instancetype)initWithStatusFromClub:(GNStatusType)status
                           backEnabled:(BOOL)enabled
                              clubName:(NSString*)clubName
                      backEventHandler:(void(^)(GNStatusVC *statusVC))handler;

- (void)backBarButtonPressedEvent:(void(^)(GNStatusVC *statusVC))block;

@end
