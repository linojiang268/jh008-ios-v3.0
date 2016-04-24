//
//  GNActivityRatingVC.m
//  GatherNew
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityRatingVC.h"
#import "GNActivityRatingView.h"
#import <IQKeyboardManager.h>
#import "UIView+GNExtension.h"
#import "UIControl+GNExtension.h"
#import <Masonry.h>
#import "GNActivityScoreVM.h"
#import "NSString+GNExtension.h"

@interface GNActivityRatingVC ()

@property (weak, nonatomic) IBOutlet GNActivityRatingView *ratingView;

#pragma mark - 默认
@property (weak, nonatomic) IBOutlet UIView *activityIntroContainView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *clubLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UIView *memoBorderView;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UIView *starContainView;
@property (weak, nonatomic) IBOutlet UIView *starView;

#pragma mark - 三星以下
@property (weak, nonatomic) IBOutlet UILabel *activityLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView2;
@property (weak, nonatomic) IBOutlet UIView *tagContainView;
@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet UILabel *lineView2;


#pragma mark - 输入反馈
@property (weak, nonatomic) IBOutlet UIView *memoContainView;
@property (weak, nonatomic) IBOutlet UILabel *memoTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (weak, nonatomic) IBOutlet UILabel *lineView3;

#pragma mark - height
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starViewBottomSpace;

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, assign) BOOL selectedStar;

@property (nonatomic, copy) void(^block)(void);

@property (strong, nonatomic) GNActivity *activity;

@property (nonatomic, strong) GNActivityScoreVM *viewModel;

/// 星级
@property (nonatomic, assign) NSUInteger starLevel;
// 反馈信息
@property (nonatomic, strong) NSString *feedbackMemo;

@end

@implementation GNActivityRatingVC

- (instancetype)initWithActivityModel:(GNActivity *)model {
    self = [super init];
    if (self) {
        self.activity = model;
        self.viewModel = [[GNActivityScoreVM alloc]init];
        self.viewModel.activity = model.id;
    }
    return self;
}

- (NSString *)stringDate {
    
    if (![NSString isBlank:self.activity.begin_time]) {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSDate *date = [dateformatter dateFromString:self.activity.begin_time];
        
        NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [c components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday) fromDate:date];
        
        NSString *stringWeekday = @"";
        switch (components.weekday) {
            case 1:
                stringWeekday = @"星期天";
                break;
            case 2:
                stringWeekday = @"星期一";
                break;
            case 3:
                stringWeekday = @"星期二";
                break;
            case 4:
                stringWeekday = @"星期三";
                break;
            case 5:
                stringWeekday = @"星期四";
                break;
            case 6:
                stringWeekday = @"星期五";
                break;
            case 7:
                stringWeekday = @"星期六";
                break;
            default:
                break;
        }
        
        return [stringWeekday stringByAppendingFormat:@"，%02d:%02d",components.hour,components.minute];
    }
    return self.activity.begin_time;
}

- (NSString *)mapURL {
    
    double lon = [[self.activity.location lastObject] doubleValue];
    double lat = [[self.activity.location firstObject] doubleValue];
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://api.map.baidu.com/staticimage?"];
    [urlString appendFormat:@"copyright=1"];
    [urlString appendFormat:@"&dpiType=ph"];
    [urlString appendFormat:@"&width=%f",CGRectGetWidth(self.mapImageView.bounds)];
    [urlString appendFormat:@"&height=%f",CGRectGetHeight(self.mapImageView.bounds)];
    [urlString appendFormat:@"&center=%f,%f",lon,lat];
    [urlString appendFormat:@"&zoom=14"];
    [urlString appendFormat:@"&scale=2"];
    [urlString appendFormat:@"&markers=%f,%f",lon,lat];
    [urlString appendFormat:@"&markerStyles=-1,%@",kActivityRatingMapIcon];
    
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(void)binding{
    self.starLevel = 5;
    
    self.activityLabel1.text = self.activity.title;
    self.dateLabel.text = [self stringDate];
    self.clubLabel.text = self.activity.team.name;
    self.memberLabel.text = [NSString stringWithFormat:@"%d人参加",self.activity.enrolled_num];
    
    [self.mapImageView setImageWithURLString:[self mapURL]];
    [self.avatarImageView setImageWithURLString:self.activity.team.logo_url];
    [self.avatarImageView2 setImageWithURLString:self.activity.team.logo_url];
    
    RAC(self.viewModel, score) = RACObserve(self, starLevel);
    RAC(self.viewModel,memo) = RACObserve(self, feedbackMemo);
    
    __weakify;
    [self.viewModel.commitResponse start:NO success:^(id response, id model) {
        __strongify;
        if (self.block) {
            self.block();
        }
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)setupUI {
    [super setupUI];
    
    self.ratingView.layer.cornerRadius = 3;
    self.ratingView.layer.masksToBounds = YES;
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, kUIScreenWidth-32, 0.5);
    layer.backgroundColor = [kUIColorWithHexUint(GNUIColorGray) CGColor];
    [self.memoBorderView.layer addSublayer:layer];
    
    CALayer *layer2 = [[CALayer alloc] init];
    layer2.frame = CGRectMake(0, CGRectGetHeight(self.memoBorderView.frame), kUIScreenWidth-32, 0.5);
    layer2.backgroundColor = [kUIColorWithHexUint(GNUIColorGray) CGColor];
    [self.memoBorderView.layer addSublayer:layer2];
    
    self.commitButton = [[UIButton alloc] init];
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ratingView addSubview:self.commitButton];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.ratingView.mas_leading);
        make.trailing.equalTo(self.ratingView.mas_trailing);
        make.bottom.equalTo(self.ratingView.mas_bottom);
        make.height.equalTo(@44);
    }];
    
    CGFloat cornerRadius = (100.0/640.0 * kUIScreenWidth) / 2.0;
    
#pragma mark - 默认
    self.activityIntroContainView.backgroundColor = [UIColor clearColor];
    self.activityLabel1.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.dateLabel.textColor = [kUIColorWithHexUint(GNUIColorBlack) colorWithAlphaComponent:0.5];
    self.lineViewWidth.constant = 0.5;
    self.lineView.backgroundColor = kUIColorWithHexUint(GNUIColorBlack);
    kUIRoundCorner(self.avatarImageView, [UIColor clearColor], 1, cornerRadius);
    self.clubLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.memberLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.memoLabel.textColor = kUIColorWithHexUint(GNUIColorPlaceholder);
    [self.memoBorderView setBackgroundColor:[UIColor clearColor]];
    [self.starContainView setBackgroundColor:[UIColor clearColor]];
    [self.starView setBackgroundColor:[UIColor clearColor]];
    [self.commitButton setHidden:YES];
    [self.commitButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen)];
    
#pragma mark - 三星以下
    self.activityLabel2.textColor = kUIColorWithHexUint(GNUIColorBlack);
    kUIRoundCorner(self.avatarImageView2, [UIColor clearColor], 1, cornerRadius);
    self.tagContainView.backgroundColor = [UIColor clearColor];
    self.lineView2.backgroundColor = kUIColorWithHexUint(GNUIColorGray);
    self.lineView2Height.constant = 0.5;
    
#pragma mark - 输入反馈
    self.memoTitleLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.lineView3.backgroundColor = kUIColorWithHexUint(GNUIColorGray);
    self.lineView3Height.constant = 0.5;
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
    self.commitButton.hidden = YES;
    self.commitButton.alpha = 0;
    
    [self.memoContainView setUserInteractionEnabled:YES];
    [self.memoBorderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputMemo)]];
    
    [self.commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectedTag:(UIButton *)sender {
    for (UIButton *button in self.tagContainView.subviews) {
        [button setSelected:NO];
    }
    [sender setSelected:YES];
    
    self.viewModel.attributes = @[@(sender.tag)];
}

- (void)selectedStar:(UIButton *)sender {
    for (UIButton *button in self.starContainView.subviews) {
        [button setSelected:button.tag <= sender.tag];
    }
    
    self.activityIntroContainView.hidden = (sender.tag <= 3);
    self.feedbackView.hidden = !(sender.tag <= 3);

    self.starLevel = sender.tag;
    
    if (!self.selectedStar) {
        self.starViewBottomSpace.constant = 44;
        self.ratingViewHeight.constant = CGRectGetHeight(self.ratingView.frame) + 44;
        [UIView animateWithDuration:0.25 animations:^{
            self.commitButton.alpha = 1;
            [self.commitButton setHidden:NO];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.selectedStar = YES;
            
        }];
    }
}

- (void)inputMemo {
    
    self.starView.hidden = YES;
    self.memoBorderView.hidden = YES;
    self.activityIntroContainView.hidden = YES;
    self.feedbackView.hidden = YES;
    self.memoContainView.hidden = NO;
    
    [self.memoTextView becomeFirstResponder];
}

- (void)completeInputMemo {
        
    self.starView.hidden = NO;
    self.memoBorderView.hidden = NO;
    self.memoContainView.hidden = YES;
    self.activityIntroContainView.hidden = (self.starLevel <= 3);
    self.feedbackView.hidden = !(self.starLevel <= 3);
    
    if (![NSString isBlank:self.memoTextView.text]) {
        self.memoLabel.text = self.memoTextView.text;
    }
    self.feedbackMemo = self.memoTextView.text;
    
    [self.memoTextView resignFirstResponder];
}

- (void)finlishRatingWithBlock:(void(^)(void))block {
    self.block = block;
}

- (void)commit {
    [self.viewModel.commitCommand execute:nil];
}

@end
