//
//  GNActivityApplyModel.m
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityApplyListModel.h"

@implementation GNActivityApplyListModel


+ (NSDictionary *)objectClassInArray{
    return @{@"applicants":[GNActivityApplyModel class]};
}

@end

@interface GNActivityApplyModel ()

@property(nonatomic, assign) BOOL isSelected;

@end

@implementation GNActivityApplyModel

+ (NSDictionary *)objectClassInArray{
    return @{@"attrs":[GNActivityApplyAttrModel class]};
}

- (void)setSelected:(BOOL) selected {
    self.isSelected = selected;
}


- (BOOL)getSelected {
    return self.isSelected;
}

@end

@implementation GNActivityApplyAttrModel


@end


