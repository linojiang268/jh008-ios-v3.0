//
//  GNActivityApplySuccessListCell.h
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNTVCBase.h"


typedef void(^OnNoteClicked)(NSInteger item);

@interface GNActivityApplySuccessListCell : GNTVCBase

- (void)setName:(NSString*)name phone:(NSString*)phone note:(NSString*)note fee:(NSInteger)fee item:(NSInteger)item OnNoteClicked:(OnNoteClicked)onNoteClicked;

@end
