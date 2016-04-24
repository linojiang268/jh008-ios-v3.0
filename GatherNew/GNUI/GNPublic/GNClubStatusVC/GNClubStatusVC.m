//
//  GNClubStatusVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubStatusVC.h"
#import "UIControl+GNExtension.h"

@interface GNClubStatusVC ()
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *action;


@property (nonatomic, copy) void(^actionHandler)(GNClubStatusVC *clubStatusVC);
@property (nonatomic, assign) GNClubStatusType status;

@end

@implementation GNClubStatusVC

+ (NSString *)sbIdentifier {
    return @"club_status";
}


+ (instancetype)initWithStatusAndAction:(GNClubStatusType)status
                   actionHandler:(void(^)(GNClubStatusVC *clubStatusVC))handler{
    
    GNClubStatusVC *controller = [GNClubStatusVC loadFromGNUI:[GNUI publicUI]];
    controller.status = status;
    controller.actionHandler = handler;
    return controller;
}


-(void)onActionButtonClick:(UIButton*) sender{
    if(self.actionHandler){
        self.actionHandler(self);
    }
}

-(void)setupUI{
    [super setupUI];
    
    self.view.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
    [self.tips setTextColor:kUIColorWithHexUint(GNUIColorBlack)];
    self.title = @"身份验证";
    self.action.layer.masksToBounds = YES;
    self.action.layer.cornerRadius  = 5.0f;
    self.action.layer.borderWidth = 2.0f;
    
    
    switch (self.status) {
        case GNClubStatusTypeJoinClubWaiting:
        {
            self.image.image = [UIImage imageNamed:@"enroll_wait"];
            self.tips.text = @"本社团需要确认身份方可加入";
            [self.action setTitle:@"立即确认" forState:UIControlStateNormal];
        }
            break;
        case GNClubStatusTypeJoinClubNeedPerfectInformation:
        {
            self.action.layer.borderColor = [kUIColorWithHexUint(GNUIColorBluePressed) CGColor];
            [self.action setBackgroundColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
            [self.action setBackgroundColor:kUIColorWithHexUint(GNUIColorBluePressed) forState:UIControlStateHighlighted];
            [self.action setTitleColor:kUIColorWithHexUint(GNUIColorBluePressed) forState:UIControlStateNormal];
            [self.action setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateHighlighted];
            
            self.image.image = [UIImage imageNamed:@"enroll_wait"];
            self.tips.text = @"本社团需要确认身份方可加入";
            [self.action setTitle:@"立即确认" forState:UIControlStateNormal];
        }
            break;
        case GNClubStatusTypeJoinClubWhiteListUserAndNeedPerfectInformation:
        {
            self.action.layer.borderColor = [kUIColorWithHexUint(GNUIColorGreenPressed) CGColor];
            [self.action setBackgroundColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
            [self.action setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
            [self.action setTitleColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateNormal];
            [self.action setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateHighlighted];
            
            self.image.image = [UIImage imageNamed:@"enroll_ok"];
            self.tips.text = @"您是社团邀请的成员，请完善信息\n即刻加入";
            [self.action setTitle:@"完善信息" forState:UIControlStateNormal];
        }
            break;
            
        case GNClubStatusTypeJoinClubSuccess:
        default:
            break;
    }

    
    [self.action addTarget:self action:@selector(onActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
@end
