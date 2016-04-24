//
//  GNLoginVC.m
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginVC.h"
#import "UIControl+GNExtension.h"
#import "GNLoginVM.h"
#import "GNInterestTagVC.h"
#import "GNPushSubscibeService.h"


@interface GNLoginVC ()<UITextFieldDelegate>

@property (nonatomic, strong) GNLoginVM *viewModel;

@end

@implementation GNLoginVC

+ (NSString *)sbIdentifier {
    return @"login";
}

- (void)setupUI {
    
    [super setupUI];
    
    
    if (self.isHideReturn) {
        self.btn_ReturnPro.hidden= YES;
    }else{
        self.btn_ReturnPro.hidden = NO;
    }
    self.btn_ReturnPro.hidden = YES;
    
    kUIRoundCorner(self.phoneTextfield, [UIColor clearColor], 0, 3);
    kUIRoundCorner(self.passwordTextfield, [UIColor clearColor], 0, 3);
    
    [self.phoneTextfield setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.passwordTextfield setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    
    [self.btn_ReturnPro setImage:[UIImage imageNamed:@"login_interest_return"] forState:UIControlStateNormal];
    [self.passwordTextfield setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.phoneTextfield setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    
    [self.loginButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    //[self.loginButton setBackgroundColor:kUIColorWithHexUint(GNUIColorDisabled) forState:UIControlStateDisabled];
    
    self.loginButton.layer.cornerRadius = 5;
}

- (void)binding {
    
    self.viewModel = [[GNLoginVM alloc] init];
    
//    self.phoneTextfield.text = @"15108273177";
//    self.passwordTextfield.text = @"123456";
    
    RAC(self.viewModel, phoneNumber) = [self.phoneTextfield.rac_textSignal map:^id(NSString *value) {
        return [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    }];
    RAC(self.viewModel, password) = self.passwordTextfield.rac_textSignal;
    
    self.loginButton.rac_command = self.viewModel.loginCommand;
    
    self.phoneTextfield.delegate = self;
    
    __weakify;
    [self.viewModel.loginResponse start:NO success:^(id response, id model) {
        [SVProgressHUD dismiss];
        [kApp showMainUI];
    } error:^(id response, NSInteger code) {
        __strongify;
        [SVProgressHUD dismiss];
        if(code == GNNetworkRequestResultStatusCodeNoUserInfo){//用户资料未完善 ->进入个人资料
            GNInterestTagVC *interestTagVC = [GNInterestTagVC initPerfectInfoWithPhone:self.viewModel.phoneNumber password:self.viewModel.password];
            [self.navigationController pushVC:interestTagVC animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
        }
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)btn_ReturnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)startLoginWithPhone:(NSString*)phone password:(NSString*)password
{
    NSMutableString *phoneWarped = [NSMutableString stringWithString:phone];
    [phoneWarped insertString:@" " atIndex:3];
    [phoneWarped insertString:@" " atIndex:8];
    self.phoneTextfield.text = phoneWarped;
    self.passwordTextfield.text = password;
    self.viewModel.phoneNumber = phone;
    self.viewModel.password = password;
    [self.passwordTextfield resignFirstResponder];
    
    [self.loginButton.rac_command execute:nil];
}

@end
