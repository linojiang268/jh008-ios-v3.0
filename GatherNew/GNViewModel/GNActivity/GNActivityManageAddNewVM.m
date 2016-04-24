//
//  GNActivityManageAddNewVM.m
//  GatherNew
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManageAddNewVM.h"
#import "GNActivityNPS.h"

@implementation GNActivityManageAddNewVM

- (instancetype)initWithActivity {
    
    __weakify;
    self.addNewResponse = [GNVMResponse responseWithTaskBlock:^{
        
        __strongify;
        GNActivityManageAddNewNPS *nps = [GNActivityManageAddNewNPS NPSWithActivityID:self.activityId attributes:self.attributes];
        
        [GNNetworkService POSTWithService:nps success:self.addNewResponse.success error:self.addNewResponse.error failure:self.addNewResponse.failure];
        
    }];
    
    return self;
}

@end
