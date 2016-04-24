//
//  GNMessageService.h
//  GatherNew
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNMessageService : NSObject

+ (void)setHaveUpdate:(BOOL)flag;
+ (BOOL)haveUpdate;

+ (void)getLatestMessageWithBlock:(void(^)(BOOL haveUpdate))block;

@end
