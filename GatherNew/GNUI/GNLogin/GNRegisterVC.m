//
//  GNRegisterVC.m
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNRegisterVC.h"
#import "UIControl+GNExtension.h"
#import "GNRegisterVM.h"
#import "GNLoginVC.h"
#import "GNMyPerfectInfoVC.h"
#import "GNPushSubscibeService.h"

@interface GNRegisterVC ()

@property (weak, nonatomic) IBOutlet UIView *view_line1;
@property (weak, nonatomic) IBOutlet UIView *view_Line2;

@property (nonatomic, strong) GNRegisterVM *viewModel;

@end

@implementation GNRegisterVC

+ (NSString *)sbIdentifier {
    return @"register";
}

- (void)setupUI {
    [super setupUI];
    self.navigationController.navigationBar.hidden = NO;
    [self.txt_RegisterCode setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lb_SendAlertPro setTextColor:kUIColorWithHexUint(GNUIColorOrange)];
    
    [self.btn_GetCodePro setBackgroundColor:kUIColorWithHexUint(GNUIColorBlue) forState:UIControlStateNormal];
    [self.btn_GetCodePro setBackgroundColor:kUIColorWithHexUint(GNUIColorBluePressed) forState:UIControlStateHighlighted];
    [self.btn_GetCodePro setBackgroundColor:kUIColorWithHexUint(GNUIColorDisabled) forState:UIControlStateDisabled];
    
    [self.btn_OkPro setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [self.btn_OkPro setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [self.btn_OkPro setBackgroundColor:kUIColorWithHexUint(GNUIColorDisabled) forState:UIControlStateDisabled];
    
    [self.view_line1 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line2 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    
    [self.txt_RegisterCode setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    
    self.lb_SendAlertPro.hidden = YES;
}

- (void)binding {
    self.viewModel = [[GNRegisterVM alloc] initWithVMType:GNVMTypeRegister];
    
    RAC(self.viewModel, inputAuthCode) = self.txt_RegisterCode.rac_textSignal;
    RAC(self.viewModel, perfectInfo) = RACObserve(self, perfectInfoNPS);
    
    __weakify;
    [RACObserve(self.viewModel,getAuthCodeTitle) subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strongify;
            [self.btn_GetCodePro setTitle:x forState:UIControlStateDisabled];
        });
    }];
    
    self.btn_GetCodePro.rac_command = self.viewModel.getAuthCodeCommand;
    self.btn_OkPro.rac_command = self.viewModel.nextCommand;
    
    [self.viewModel.getAuthCodeResponse start:NO success:^(id response, id model){
        __strongify;
        self.lb_SendAlertPro.hidden = NO;
    } error:^(id response, NSInteger code) {
        __strongify;
        self.lb_SendAlertPro.hidden = YES;
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        __strongify;
        self.lb_SendAlertPro.hidden = YES;
        [SVProgressHUD showInfoWithStatus:@"获取验证码失败"];
    }];
    
    [self.viewModel.nextResponse start:NO success:^(id response, id model){
        __strongify;
        [SVProgressHUD dismiss];
        [self login];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"注册失败!"];
    }];
}

- (void)login {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:NSClassFromString(@"GNLoginVC")]) {
            [self.navigationController popToViewController:obj animated:YES];
            [(GNLoginVC*)obj startLoginWithPhone:self.viewModel.perfectInfo.phoneNumber password:self.viewModel.perfectInfo.passWord];
            *stop = YES;
        }
    }];
}

@end
