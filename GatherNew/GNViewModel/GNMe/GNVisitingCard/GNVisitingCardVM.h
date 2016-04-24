//
//  GNVisitingCardVM.h
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNVisitingCardModel.h"

@interface GNVisitingCardVM : GNVMBase

- (instancetype)initWithUserId:(NSUInteger)userId gender:(GNGender)gender;
- (instancetype)initWithUserModel:(GNVisitingCardModel *)model;

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, assign) GNGender gender;
@property (nonatomic, strong) GNVisitingCardModel *model;
@property (nonatomic, strong) GNVMResponse *userInfoResponse;

@end
