//
//  GNVisitingCardModel.m
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVisitingCardModel.h"

@implementation GNVisitingCardModel

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"birthday"]) {
        
    }else if ([property.name isEqualToString:@"avatar_url"]) {
        return [NSURL URLWithString:oldValue];
    }
    return oldValue;
}

@end
