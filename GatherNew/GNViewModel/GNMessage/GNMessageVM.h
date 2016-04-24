//
//  GNClubMessageVM.h
//  GatherNew
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNMessageModel.h"

typedef NS_ENUM(NSUInteger, GNMessageType) {
    GNMessageTypeClub       = 2,
    GNMessageTypeSystem     = 1,
};

@interface GNMessageVM : GNVMBase

- (instancetype)initWithType:(GNMessageType)type;

@property (nonatomic, strong, readonly) NSString *badgeValue;

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, strong) GNVMResponse *refreshResponse;

@end
