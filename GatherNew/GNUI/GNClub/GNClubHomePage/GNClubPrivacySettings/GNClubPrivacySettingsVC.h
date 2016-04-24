//
//  GNClubPrivacySettingsVC.h
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTableVCBase.h"

@interface GNClubPrivacySettingsVC : GNTableVCBase

- (instancetype)initWithVisibility:(GNClubMemberVisibility)visibility
                     changeHandler:(void(^)(GNClubMemberVisibility visibility))handler;

@end
