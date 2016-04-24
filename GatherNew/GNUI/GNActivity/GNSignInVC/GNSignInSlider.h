//
//  GNSignInSlider.h
//  TestSlider
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNSignInSlider : UISlider

- (void)endNoticeBlock:(void(^)(void))block;

- (void)setEnd:(BOOL)end;

@end
