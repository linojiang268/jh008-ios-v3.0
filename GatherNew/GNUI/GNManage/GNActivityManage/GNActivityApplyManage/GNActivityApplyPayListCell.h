//
//  GNActivityApplyPayListCell.h
//  GatherNew
//
//  Created by Culmore on 15/10/4.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTVCBase.h"


typedef void(^OnDetailButtonClicked)(NSInteger item);


@interface GNActivityApplyPayListCell : GNTVCBase

@property(nonatomic, assign) NSInteger item;
@property(nonatomic, copy) OnDetailButtonClicked onDetailButtonClicked;

- (void)setName:(NSString*)name phone:(NSString*)phone fee:(NSInteger)fee item:(NSInteger)item OnDetailButtonClicked:(OnDetailButtonClicked) onDetailButtonClicked;

@end
