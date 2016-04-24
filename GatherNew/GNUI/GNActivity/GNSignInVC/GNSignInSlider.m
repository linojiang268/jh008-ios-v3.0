//
//  GNSignInSlider.m
//  TestSlider
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNSignInSlider.h"

@interface GNSignInSlider ()

@property (nonatomic, strong) UILabel *labelUnsigned;
@property (nonatomic, strong) UILabel *labelSigned;

@property (nonatomic, copy) void(^endBlock)(void);

@property (nonatomic, assign) BOOL isEnd;

@end

@implementation GNSignInSlider

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 160, 45)];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    UIImageView *borderView = [[UIImageView alloc] initWithFrame:self.bounds];
    borderView.image = [UIImage imageNamed:@"sign_in_slider_background_ok"];
    [self addSubview:borderView];
    
    self.labelUnsigned = [[UILabel alloc] init];
    self.labelUnsigned.text = @"请交工作人员验证";
    self.labelUnsigned.font = [UIFont systemFontOfSize:12];
    self.labelUnsigned.textColor = kUIColorWithHexUint(GNUIColorDisabled);
    [self.labelUnsigned sizeToFit];
    
    CGRect r = self.labelUnsigned.bounds;
    r.origin.x = 50;
    r.origin.y = CGRectGetMidY(self.bounds)-CGRectGetMidY(r);
    self.labelUnsigned.frame = r;
    
    [self addSubview:self.labelUnsigned];
    
    self.labelSigned = [[UILabel alloc] init];
    self.labelSigned.text = @"已签到";
    self.labelSigned.font = [UIFont systemFontOfSize:12];
    self.labelSigned.textColor = kUIColorWithHexUint(GNUIColorDisabled);
    [self.labelSigned sizeToFit];
    self.labelSigned.center = borderView.center;
    
    [self.labelSigned setHidden:YES];
    [self addSubview:self.labelSigned];
    
    [self setMinimumValue:0];
    [self setMaximumValue:100];
    [self setValue:2 animated:YES];
    [self setThumbImage:[UIImage imageNamed:@"sign_in_ nonius_no"] forState:UIControlStateNormal];
    [self setMinimumTrackImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)endNoticeBlock:(void (^)(void))block {
    self.endBlock = block;
}

- (void)valueChange:(UISlider *)slider {
    if (slider.value < 2) {
        slider.value = 2;
        self.labelUnsigned.hidden = NO;
    }else if (slider.value > 98) {
        if (!self.isEnd) {
            self.value = 98;
            [self setEnd:YES];
            if (self.endBlock) {
                self.endBlock();
                self.isEnd = YES;
            }
        }
    }
//    else {
//        [self setEnd:NO];
//    }
}

- (void)touchEnd:(UISlider *)slider {
    if (slider.value < 98) {
        [slider setValue:2.0 animated:YES];
        [self.labelUnsigned setHidden:NO];
    }
}

- (void)setEnd:(BOOL)end {
    if (end) {
        [self setValue:98];
//        [self setThumbImage:[UIImage imageNamed:@"sign_in_ nonius_ok"] forState:UIControlStateNormal];
        [self setUserInteractionEnabled:NO];
        [self.labelUnsigned setHidden:YES];
        [self.labelSigned setHidden:NO];
    }else {
        [self setValue:2];
//        [self setThumbImage:[UIImage imageNamed:@"sign_in_ nonius_no"] forState:UIControlStateNormal];
        [self setUserInteractionEnabled:YES];
        [self.labelUnsigned setHidden:NO];
        [self.labelSigned setHidden:YES];
    }
}

@end
