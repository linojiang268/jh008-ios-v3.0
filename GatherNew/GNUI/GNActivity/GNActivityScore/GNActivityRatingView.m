//
//  GNActivityRatingView.m
//  GatherNew
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityRatingView.h"
#import "UIView+GNExtension.h"
#import "UIControl+GNExtension.h"

@interface GNActivityRatingView ()

#pragma mark - 默认
@property (weak, nonatomic) IBOutlet UIView *activityIntroContainView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *clubLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UIView *memoBorderView;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UIView *starContainView;

#pragma mark - 三星以下
@property (weak, nonatomic) IBOutlet UILabel *activityLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView2;
@property (weak, nonatomic) IBOutlet UIView *tagContainView;
@property (weak, nonatomic) IBOutlet UIView *feedbackView;

#pragma mark - 输入反馈
@property (weak, nonatomic) IBOutlet UIView *memoContainView;
@property (weak, nonatomic) IBOutlet UILabel *memoTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;


@property (nonatomic, copy) void(^didSelectedStarBlock)(void);

@end

@implementation GNActivityRatingView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GNActivityRatingView class]) owner:nil options:nil] firstObject];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.memoBorderView addTopAndBottomLineWithDefaultSetting];
}

- (void)setup {
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;

    #pragma mark - 默认
    self.activityIntroContainView.backgroundColor = [UIColor clearColor];
    self.activityLabel1.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.dateLabel.textColor = [kUIColorWithHexUint(GNUIColorBlack) colorWithAlphaComponent:0.5];
    self.lineViewHeight.constant = 0.5;
    self.lineView.backgroundColor = kUIColorWithHexUint(GNUIColorGray);
    kUIRoundCorner(self.avatarImageView, kUIColorWithHexUint(0xff959595), 1, 55/2);
    self.clubLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.memberLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.memoLabel.textColor = kUIColorWithHexUint(GNUIColorPlaceholder);
    [self.memoBorderView setBackgroundColor:[UIColor clearColor]];
    [self.starContainView setBackgroundColor:[UIColor clearColor]];
    [self.commitButton setHidden:YES];
    [self.commitButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen)];
    
    #pragma mark - 三星以下
    self.activityLabel2.textColor = kUIColorWithHexUint(GNUIColorBlack);
    kUIRoundCorner(self.avatarImageView2, kUIColorWithHexUint(0xff959595), 1, 40/2);
    self.tagContainView.backgroundColor = [UIColor clearColor];
    
    #pragma mark - 输入反馈
    self.memoTitleLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    [self.completeButton setTitleColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [self.completeButton addTarget:self action:@selector(completeInputMemo) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIButton *button in self.tagContainView.subviews) {
        kUIRoundCorner(button, kUIColorWithHexUint(GNUIColorGray), 0.5, 2);
        [button setTitleColor:kUIColorWithHexUint(GNUIColorGrayBlack) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectedTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton *button in self.starContainView.subviews) {
        [button addTarget:self action:@selector(selectedStar:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.activityIntroContainView.hidden = NO;
    self.feedbackView.hidden = YES;
    self.memoContainView.hidden = YES;
    
    [self.memoContainView setUserInteractionEnabled:YES];
    [self.memoBorderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputMemo)]];
}

- (void)selectedTag:(UIButton *)sender {
    for (UIButton *button in self.tagContainView.subviews) {
        [button setSelected:NO];
    }
    [sender setSelected:YES];
    
    self.feedbackTag = sender.tag;
}

- (void)selectedStar:(UIButton *)sender {
    for (UIButton *button in self.starContainView.subviews) {
        [button setSelected:button.tag <= sender.tag];
    }
    [self.commitButton setHidden:NO];
    self.activityIntroContainView.hidden = (sender.tag <= 3);
    self.feedbackView.hidden = !(sender.tag <= 3);
    
    if (self.superview && kUIScreenHeight == 480) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    }
    
    self.starLevel = sender.tag;
}

- (void)inputMemo {
    self.activityIntroContainView.hidden = YES;
    self.feedbackView.hidden = YES;
    self.memoContainView.hidden = NO;
    
    if (self.superview && kUIScreenHeight == 480) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)completeInputMemo {
    self.activityIntroContainView.hidden = NO;
    self.feedbackView.hidden = YES;
    self.memoContainView.hidden = YES;
    self.memoLabel.text = self.memoTextView.text;
    
    if (self.superview && kUIScreenHeight == 480) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    }
    
    self.feedbackMemo = self.memoTextView.text;
}


- (void)didSelectedStarWithBlock:(void(^)(void))block {
    self.didSelectedStarBlock = block;
}

@end
