//
//  GNActivitySignInVC.m
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivitySignInVC.h"
#import "UIView+GNExtension.h"
#import "GNSignInSlider.h"

@interface GNActivitySignInVC ()

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *titleView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel2;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *errorLabelContainView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) GNSignInSlider *slider;
@property (weak, nonatomic) IBOutlet UIView *sliderContainView;

@property (nonatomic, strong) GNActivitySignInVM *viewModel;

@property (nonatomic, copy) void(^successBlock)(GNActivitySignInModel *model);
@property (nonatomic, copy) void(^noApplyCallback)(void);
@property (nonatomic, copy) void(^stepsErrorCallback)(void);
@property (nonatomic, copy) void(^backCallback)(void);

@end

@implementation GNActivitySignInVC

- (void)setupUI {
    [super setupUI];

    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 74.5, kUIScreenWidth-44, 0.5);
    layer.backgroundColor = [kUIColorWithHexUint(GNUIColorGray) CGColor];
    [self.titleView.layer addSublayer:layer];
    
    CALayer *layer2 = [[CALayer alloc] init];
    layer2.frame = CGRectMake(0, 74.5, kUIScreenWidth-44, 0.5);
    layer2.backgroundColor = [kUIColorWithHexUint(GNUIColorGray) CGColor];
    [self.titleView2.layer addSublayer:layer2];
    
    CALayer *layer3 = [[CALayer alloc] init];
    layer3.frame = CGRectMake(0, 0, kUIScreenWidth-44, 0.5);
    layer3.backgroundColor = [kUIColorWithHexUint(GNUIColorGray) CGColor];
    [self.errorLabelContainView.layer addSublayer:layer3];
    
    self.roundView.layer.cornerRadius = 3;
    self.roundView.layer.masksToBounds = YES;
    self.roundView2.layer.cornerRadius = 3;
    self.roundView2.layer.masksToBounds = YES;
    
    self.roundView.backgroundColor = [UIColor whiteColor];
    self.roundView2.backgroundColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView2.backgroundColor = [UIColor clearColor];
    [self.backButton setTitleColor:kUIColorWithHexUint(GNUIColorBlack) forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    self.slider = [[GNSignInSlider alloc] init];
    self.sliderContainView.userInteractionEnabled = YES;
    [self.sliderContainView addSubview:self.slider];
    
    self.errorLabel.text = @"";
    
    self.roundView2.hidden = YES;
    
    NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [c components:NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    
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
    
    NSString *date = [NSString stringWithFormat:@"%@，%02d:%02d",stringWeekday,(int)components.hour,(int)components.minute];
    self.dateLabel.text = date;
    self.dateLabel2.text = date;
}

- (void)back {
    if (self.backCallback) {
        self.backCallback();
    }
}

- (instancetype)initWithSigninURL:(NSString *)url
                          success:(void(^)(GNActivitySignInModel *model))success
                  noApplyCallback:(void(^)(void))noApplyCallback
               stepsErrorCallback:(void(^)(void))stepsErrorCallback
                     backCallback:(void(^)(void))callback
{
    self = [super init];
    if (self) {
        self.viewModel = [[GNActivitySignInVM alloc] initWithSignInIdentifier:url];
        self.successBlock = success;
        self.noApplyCallback = noApplyCallback;
        self.stepsErrorCallback = stepsErrorCallback;
        self.backCallback = callback;
    }
    return self;
}

- (void)binding {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    __weakify;
    [self.viewModel.signInInfoResponse start:YES success:^(id response, GNActivitySignInModel *model) {
        [SVProgressHUD dismiss];
        __strongify;
        self.numberLabel.text = [kNumber(model.step) stringValue];
        self.titleLabel.text = model.activity_title;
        self.titleLabel2.text = model.activity_title;
        
        GNActivitySignInItemModel *itemSigned = nil, *itemNotSigned = nil;
        for (GNActivitySignInItemModel *itemTemp in model.check_list) {
            if (itemTemp.status == 1) {
                itemSigned = itemTemp;
            }else{
                if(itemNotSigned != nil)
                    itemNotSigned = itemTemp;
            }
        }
        
        if(itemSigned != nil) {
            if (model.step == itemSigned.step) {
                if (self.successBlock) {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"你已经签过到了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    self.successBlock(model);
                }
            }else{
                if (self.stepsErrorCallback && itemNotSigned != nil) {
                    [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"步骤%ld未签到",(long)(itemNotSigned.step)] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    self.stepsErrorCallback();
                }
            }
        }
    } error:^(id response, NSInteger code) {
        __strongify;
        [SVProgressHUD dismiss];
        
        if (self.noApplyCallback) {
            self.noApplyCallback();
        }
        
    } failure:^(id req, NSError *error) {
        __strongify;
        [SVProgressHUD dismiss];
        if (self.noApplyCallback) {
            self.noApplyCallback();
        }
    }];
    
    [self.viewModel.signInResponse start:NO success:^(id response, GNActivitySignInModel *model) {
        [SVProgressHUD dismiss];
        __strongify;
        if (self.successBlock) {
            self.successBlock(model);
        }
    } error:^(id response, NSInteger code) {
        __strongify;
        [SVProgressHUD dismiss];
        self.errorLabel.text = [response objectForKey:@"message"];
        
        self.roundView.hidden = YES;
        self.roundView2.hidden = NO;
        
    } failure:^(id req, NSError *error) {
        __strongify;
        [SVProgressHUD dismiss];
        self.errorLabel.text = @"连接服务器失败";
        
        self.roundView.hidden = YES;
        self.roundView2.hidden = NO;
    }];
    
    [self.slider endNoticeBlock:^{
        __strongify;
        DDLogError(@"sadfads");
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [self.viewModel.signInResponse start];
    }];
}

@end
