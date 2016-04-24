//
//  GNVisitingCardNPS.m
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVisitingCardNPS.h"
#import "GNVisitingCardModel.h"

@implementation GNVisitingCardNPS

+ (instancetype)NPSWithUserId:(NSUInteger)userId {
    return [[GNVisitingCardNPS alloc] initWithURL:@"/api/user/profile"
                                       parameters:@{@"user_id" : @(userId)}
                                mappingModelClass:[GNVisitingCardModel class]];
}

@end
