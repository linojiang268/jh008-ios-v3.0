//
//  GNModelBase.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "GNModel.h"

@interface GNModelBase : NSObject<GNModelCacheProtocol>

+ (NSString *)localCacheIdentifier;

@end
