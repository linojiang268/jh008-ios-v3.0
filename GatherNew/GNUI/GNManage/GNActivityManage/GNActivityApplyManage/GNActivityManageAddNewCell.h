//
//  GNActivityManageAddNewCell.h
//  GatherNew
//
//  Created by apple on 15/10/23.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//


@interface GNActivityManageAddNewCell : UIView

@property(retain, nonatomic)UILabel* titleView;
@property(retain, nonatomic)UITextField* inputView;

-(void)setTitleText:(NSString *) title;

-(NSString *)getInputedValue;

@end
