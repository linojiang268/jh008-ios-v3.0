//
//  GNActivityRatingView.h
//  GatherNew
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNActivityRatingView : UIView

@property (nonatomic, assign) NSUInteger starLevel;
@property (nonatomic, assign) NSUInteger feedbackTag;
@property (nonatomic, strong) NSString *feedbackMemo;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

- (void)didSelectedStarWithBlock:(void(^)(void))block;

@end
