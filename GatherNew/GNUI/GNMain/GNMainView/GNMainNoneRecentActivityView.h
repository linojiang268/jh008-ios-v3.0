//
//  GNMainNoneRecentActivityView.h
//  GatherNew
//
//  Created by yuanjun on 15/9/19.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnActionButtonClick)(UIView* v);

@interface GNMainNoneRecentActivityView : UIView

@property (nonatomic, copy) OnActionButtonClick onActionButtonClickBlock;

-(instancetype)initWithTips:(NSString*)tips action:(OnActionButtonClick)onActionButtonClickBlock;

@end
