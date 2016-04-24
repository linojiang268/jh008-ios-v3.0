//
//  GNActivitySignInManageCell.h
//  GatherNew
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTVCBase.h"
#import "GNActivityCheckInListModel.h"


@interface GNActivitySignInManageCell : GNTVCBase


- (void)bindingModel:(GNActivityCheckInModel*)model subStatus:(NSUInteger)subStatus OnCheckInClick:(void(^)(GNActivityCheckInModel * who))onCheckInClick;
@end
