//
//  GNUpdatePasswordVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNUpdatePasswordVC.h"
#import "UIControl+GNExtension.h"
#import "GNRegisterVM.h"

@interface GNUpdatePasswordVC ()<UITextFieldDelegate>

@property (nonatomic, strong) GNRegisterVM *viewModel;

@end

@implementation GNUpdatePasswordVC


+ (NSString *)sbIdentifier {
    return @"updatePassword";
}

- (void)setupUI {
    
    [super setupUI];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self.lbPhoneTitlePro setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lbpwdTitlePro setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lbRegisterCodeTitlePro setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.txtPhonePro setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.txtPWDPro setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.txtRegisterCodePro setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    
    [self.txtPhonePro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txtPWDPro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txtRegisterCodePro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
   
    [self.btnGetCodePro setBackgroundColor:kUIColorWithHexUint(GNUIColorBlue) forState:UIControlStateNormal];
    [self.btnGetCodePro setBackgroundColor:kUIColorWithHexUint(GNUIColorBluePressed) forState:UIControlStateHighlighted];
    [self.btnGetCodePro setBackgroundColor:kUIColorWithHexUint(GNUIColorDisabled) forState:UIControlStateDisabled];
    
    [self.btnNextPro setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [self.btnNextPro setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [self.btnNextPro setBackgroundColor:kUIColorWithHexUint(GNUIColorDisabled) forState:UIControlStateDisabled];
    
    
    [self.view_Line1 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line2 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line3 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line4 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
}

- (void)binding {
    
    self.viewModel = [[GNRegisterVM alloc]initWithVMType:GNVMTypeUpdatePassword];
    
    RAC(self.viewModel,phoneNumber) = [self.txtPhonePro.rac_textSignal map:^id(NSString *value) {
        return [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    }];
    RAC(self.viewModel,passwordNew) = self.txtPWDPro.rac_textSignal;
    RAC(self.viewModel,inputAuthCode) = self.txtRegisterCodePro.rac_textSignal;
    
    self.btnGetCodePro.rac_command = self.viewModel.getAuthCodeCommand;
    self.btnNextPro.rac_command = self.viewModel.nextCommand;
    
    __weakify;
    [RACObserve(self.viewModel,getAuthCodeTitle) subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strongify;
            [self.btnGetCodePro setTitle:x forState:UIControlStateDisabled];
        });
    }];
    
    self.txtPhonePro.delegate = self;
    
    [self.viewModel.getAuthCodeResponse start:NO success:^(id response, id model){
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"获取验证码失败"];
    }];
    
    [self.viewModel.nextResponse start:NO success:^(id response, id model){
        [SVProgressHUD dismiss];
        __strongify;
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"修改密码失败！"];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ((textField.text.length == 3 || textField.text.length == 8) && ![string isEqualToString:@""]) {
        textField.text = [textField.text stringByAppendingString:@" "];
    }
    
    if (textField.text.length < 13 || [string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

@end
