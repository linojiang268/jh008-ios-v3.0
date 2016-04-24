//
//  GNSectionHeadView.h
//  GatherNew
//
//  Created by yuanjun on 15/9/18.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnSectionClicked)(UIView* v);


@interface GNSectionHeadView : UIView

@property(nonatomic, copy) OnSectionClicked onSectionClicked;

-(instancetype)initWithSectionName:(NSString*)name ShowMore:(BOOL)showMore OnSectionClicked:(OnSectionClicked) onSectionClicked;


@end
