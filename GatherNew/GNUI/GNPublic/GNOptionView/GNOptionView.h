//
//  GNOptionView.h
//  GatherNew
//
//  Created by yuanjun on 15/9/19.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnItemClick)(NSInteger position, NSString* option);


@interface GNOptionView : UIView

@property(nonatomic, copy) OnItemClick onItemClick;

- (instancetype)initWithOptions:(NSArray*)options icons:(NSArray*)icons position:(CGPoint)position arrowOffset:(CGFloat)offset expectSize:(CGSize)expectSize;
-(void)showRedDotAtRow:(NSInteger)row show:(BOOL)show;
-(void)removeAllRedDotAtRow;
-(void)show;
-(void)hide;
-(void)autoShowOrHide;

@end
