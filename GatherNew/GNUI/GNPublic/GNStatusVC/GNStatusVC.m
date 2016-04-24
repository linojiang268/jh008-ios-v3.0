//
//  GNStatusVC.m
//  GatherNew
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNStatusVC.h"

@interface GNStatusVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *mainStatus;
@property (weak, nonatomic) IBOutlet UILabel *subStatus;
@property (weak, nonatomic) IBOutlet UILabel *tips;


@property (nonatomic, assign) GNStatusType status;
@property (nonatomic, assign) BOOL backEnabled;
@property (nonatomic, assign) BOOL needPayment;
@property (nonatomic, copy) void(^backEventHandler)(GNStatusVC *statusVC);
@property (nonatomic, strong) NSString *clubName;

@end

@implementation GNStatusVC

+ (NSString *)sbIdentifier {
    return @"status";
}

+ (instancetype)statusWithStatus:(GNStatusType)status
                     backEnabled:(BOOL)enabled
                     needPayment:(BOOL)payment
                backEventHandler:(void(^)(GNStatusVC *statusVC))handler {
    GNStatusVC *controller = [GNStatusVC loadFromGNUI:[GNUI publicUI]];
    controller.status = status;
    controller.backEnabled = enabled;
    controller.needPayment = payment;
    controller.backEventHandler = handler;
    return controller;
}


+ (instancetype)initWithStatusFromClub:(GNStatusType)status
                     backEnabled:(BOOL)enabled
                     clubName:(NSString*)clubName
                backEventHandler:(void(^)(GNStatusVC *statusVC))handler {
    GNStatusVC *controller = [GNStatusVC loadFromGNUI:[GNUI publicUI]];
    controller.status = status;
    controller.backEnabled = enabled;
    controller.clubName = clubName;
    controller.backEventHandler = handler;
    return controller;
}


- (void)backBarButtonPressedEvent:(void(^)(GNStatusVC *statusVC))block {
    self.backEventHandler = block;
}

- (void)backBarButtonItemPressed:(UIBarButtonItem *)sender {
    if (self.backEventHandler) {
        self.backEventHandler(self);
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupUI {
    [super setupUI];
    
    if (!self.backEnabled) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:Nil];
    }
    
    self.view.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
    [self.mainStatus setTextColor:kUIColorWithHexUint(GNUIColorBlack)];
    [self.subStatus setTextColor:kUIColorWithHexUint(GNUIColorBlack)];
    [self.tips setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    
    switch (self.status) {
        case GNStatusTypeClubJoinOK:
        {
            self.title = @"申请结果";
            self.imageView.image = [UIImage imageNamed:@"enroll_ok"];
            self.mainStatus.text = @"恭喜你";
            self.subStatus.text = [NSString stringWithFormat:@"加入%@", self.clubName];
            self.tips.text = @"你可以在社团主页查看社团相关信息";
        }
            break;
        case GNStatusTypeClubJoinVerify:
        {
            self.title = @"申请结果";
            self.imageView.image = [UIImage imageNamed:@"enroll_wait"];
            self.mainStatus.text = @"待审核";
            self.subStatus.text = @"团长审核通过后，您方可加入";
            //self.tips.text = @"请到  “我的社团”  中实时查看审核结果";
            self.tips.text =@"";
        }
            break;
        case GNStatusTypeSignUpForActiveSuccess:
        {
            self.title = @"报名结果";
            self.imageView.image = [UIImage imageNamed:@"enroll_ok"];
            self.mainStatus.text = @"恭喜你";
            self.subStatus.text = @"成功报名本次活动";
            self.tips.text = @"请到  “活动详情”  中查看活动手册";
        }
            break;
        case GNStatusTypeSignUpForActiveWaiting:
        {
            self.title = @"报名结果";
            self.imageView.image = [UIImage imageNamed:@"enroll_wait"];
            self.mainStatus.text = @"待审核";
            self.subStatus.text = self.needPayment ? @"主办方审核通过后，将通知您支付费用" : @"主办方审核通过后，您将获得参与资格";
            self.tips.text = @"请到  “首页>参与的活动”  中查看审核结果";
        }
            break;
        case GNStatusTypeSignUpForActivePayFailed:
        {
            self.title = @"支付结果";
            self.imageView.image = [UIImage imageNamed:@"enroll_error"];
            self.mainStatus.text = @"对不起";
            self.subStatus.text = @"您没有支付成功，请重试";
            self.tips.text = @"请换一种方式付款";
        }
            break;
        default:
            break;
    }
}

@end
