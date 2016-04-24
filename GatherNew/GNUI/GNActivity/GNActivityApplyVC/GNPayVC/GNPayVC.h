//
//  GNPayVC.h
//  GatherNew
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseVC.h"

@interface GNPayVC : GNActivityBaseVC

- (instancetype)initWithOrderNumber:(NSString *)orderNumber price:(NSString *)price expireAt:(NSString *) expireAt enrollEndAt:(NSString *) enrollEndAt backEventHandler:(void(^)(GNPayVC *payVC))handler;
- (void)backBarButtonPressedEvent:(void(^)(GNPayVC *payVC))handler;

@end
