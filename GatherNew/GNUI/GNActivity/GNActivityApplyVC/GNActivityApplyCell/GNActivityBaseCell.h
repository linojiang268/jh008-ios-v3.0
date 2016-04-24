//
//  GNActivityBaseCell.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTVCBase.h"

@protocol GNActivityDetailsDelegate <NSObject>

-(void)callPhone:(NSString*)phone;
-(void)intoMapShowLocaton:(id)sender;
-(void)intoMapShowLine:(id)sender;
-(void)showActivityPicture:(id)sender;

-(void)showActivityFlow:(id)sender;
-(void)showActivityAblum:(id)sender;
-(void)showActivityFile:(id)sender;
-(void)showActivityRoadMap:(id)sender;
-(void)showActivityMembers:(id)sender;

@end

@interface GNActivityBaseCell : GNTVCBase

@property (weak, nonatomic) id<GNActivityDetailsDelegate> delegate;

@end
