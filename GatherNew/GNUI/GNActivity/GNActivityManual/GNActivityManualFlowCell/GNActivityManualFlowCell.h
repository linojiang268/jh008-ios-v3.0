//
//  GNActivityManualFlowCell.h
//  GatherNew
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTVCBase.h"

@interface GNActivityManualFlowCell : GNTVCBase

@property (weak, nonatomic) IBOutlet UILabel *signedNumerLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowLabel;

- (CGFloat)cellHeight;

- (void)hideSignInView;

@end
