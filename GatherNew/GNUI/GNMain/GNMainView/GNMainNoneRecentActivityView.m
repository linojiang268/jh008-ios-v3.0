//
//  GNMainNoneRecentActivityView.m
//  GatherNew
//
//  Created by yuanjun on 15/9/19.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMainNoneRecentActivityView.h"
#import "UIColor+GNExtension.h"

@interface GNMainNoneRecentActivityView ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation GNMainNoneRecentActivityView


- (instancetype)initWithTips:(NSString*)tips action:(OnActionButtonClick)onActionButtonClickBlock
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"GNMainNoneRecentActivityView" owner:nil options:nil] firstObject];;
    if (self) {
        self.onActionButtonClickBlock = onActionButtonClickBlock;
        [self.actionButton setBackgroundImage:[UIColor createImageWithColor:kUIColorWithHexUint(GNUIColorBlue)]
                                     forState:UIControlStateNormal];
        [self.actionButton setBackgroundImage:[UIColor createImageWithColor:kUIColorWithHexUint(GNUIColorBluePressed)]
                                     forState:UIControlStateSelected|UIControlStateHighlighted];
        [self.actionButton setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
        [self.actionButton setTitleColor:kUIColorWithHexUint(GNUIColorBlack) forState:UIControlStateSelected|UIControlStateHighlighted];
        
        self.actionButton.tintColor = kUIColorWithHexUint(GNUIColorBluePressed);
        
        if(tips != nil){
            self.tipsLabel.text = tips;
        }
    }
    return self;
}



- (IBAction)onActionButtonClick:(UIButton *)sender {
    if(self.onActionButtonClickBlock){
        self.onActionButtonClickBlock(self);
    }
}

@end
