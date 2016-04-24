//
//  GNActivitiyApplyVerifyListCell.h
//  GatherNew
//
//  Created by Culmore on 15/10/3.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNTVCBase.h"


typedef void(^OnSelected)(NSInteger item, BOOL selected);
typedef void(^OnDetailButtonClicked)(NSInteger item);

@interface GNActivitiyApplyVerifyListCell : GNTVCBase

@property(nonatomic, assign) NSInteger item;
@property(nonatomic, copy) OnSelected onSelected;
@property(nonatomic, copy) OnDetailButtonClicked onDetailButtonClicked;


- (void)setName:(NSString*)name phone:(NSString*)phone fee:(NSInteger)fee item:(NSInteger)item selected:(BOOL) selected  OnSelected:(OnSelected) onSelected OnDetailButtonClicked:(OnDetailButtonClicked) onDetailButtonClicked;
@end
