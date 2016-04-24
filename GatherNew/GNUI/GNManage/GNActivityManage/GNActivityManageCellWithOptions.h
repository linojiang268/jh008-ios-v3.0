//
//  GNActivityManageCellWithOptions.h
//  GatherNew
//
//  Created by yuanjun on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNTVCBase.h"

@interface GNActivityManageCellWithOptions : GNTVCBase

@property (nonatomic, assign) NSUInteger indexTag;

@property (weak, nonatomic) IBOutlet UIView *activityEnrollView;
@property (weak, nonatomic) IBOutlet UIView *activityCheckInView;

@property (weak, nonatomic) IBOutlet UIView *activityMessageView;



- (void)setActivityId:(NSInteger) activityId name:(NSString*)name time:(NSString*)time state:(NSInteger)state enableMessage:(BOOL)enableMessage;

@end
