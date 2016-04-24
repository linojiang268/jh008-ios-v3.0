//
//  GNClubActiveAlbumVM.h
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNClubAlbumModel.h"

@interface GNClubActiveAlbumVM : GNVMBase

@property (nonatomic, assign) NSUInteger clubId;
@property (nonatomic, assign) NSUInteger page;

- (instancetype)initWithClubId:(NSUInteger)clubId;

@property (nonatomic, strong) NSMutableArray *activityArray;
@property (nonatomic, strong) GNVMResponse *refreshResponse;

@end
