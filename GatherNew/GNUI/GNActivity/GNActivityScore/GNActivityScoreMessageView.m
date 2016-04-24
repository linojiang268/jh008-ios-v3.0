//
//  GNActivityScoreMessageView.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityScoreMessageView.h"
#import "UIControl+GNExtension.h"

@implementation GNActivityScoreMessageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"GNActivityScoreMessageView" owner:nil options:nil] firstObject];
        self.mutArray = [NSMutableArray array];
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    self.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
 
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setBackgroundColor:kUIColorWithHexUint(GNUIColorGrayWhite) forState:UIControlStateNormal];
            [(UIButton *)view setBackgroundColor:kUIColorWithHexUint(GNUIColorDarkgray) forState:UIControlStateSelected];
            [(UIButton *)view setTitleColor:kUIColorWithHexUint(GNUIColorGrayBlack) forState:UIControlStateNormal];
            [(UIButton *)view setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateSelected];
            [view.layer setBorderColor:[kUIColorWithHexUint(GNUIColorGray) CGColor]];
            [view.layer setBorderWidth:1];
        }
    }
}

- (IBAction)btnScoreAction:(id)sender {
    
    UIButton *button = sender;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setSelected:NO];
        }
    }
    [button setSelected:YES];
    [self.mutArray removeAllObjects];
    [self.mutArray addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
}


@end
