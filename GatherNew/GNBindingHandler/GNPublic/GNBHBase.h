//
//  GNBHBase.h
//  GatherNew
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNBHBase : NSObject

@property (nonatomic, weak) id GNUI;

- (instancetype)initWithGNUI:(id)UI;
+ (instancetype)BHWithGNUI:(id)UI;

- (void)binding;

@end
