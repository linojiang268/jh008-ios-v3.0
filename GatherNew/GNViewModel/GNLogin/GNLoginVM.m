//
//  GNLoginVM.m
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginVM.h"
#import "GNLoginNPS.h"
#import "NSString+GNExtension.h"
#import "GNPushSubscibeService.h"
#import "GNLoginVC.h"

@interface GNLoginVM () <UIAlertViewDelegate>

@property(nonatomic, strong) UIAlertView* lertView;

@end

@implementation GNLoginVM

- (void)initModel {
    self.loginResponse = [[GNVMResponse alloc] init];
    
    @weakify(self);
    
    RACSignal *signal = [[RACSignal combineLatest:@[RACObserve(self, phoneNumber),
                                                    RACObserve(self, password)]]
                                       reduceEach:^id(NSString *phoneNumber, NSString *password)
    {
        return @(YES);
        //return @((phoneNumber.length == 11 && password.length >=6 &&password.length <= 18));
    }];
    
    self.loginCommand = [[RACCommand alloc] initWithEnabled:signal signalBlock:^RACSignal *(id input)
    {
        @strongify(self);
        
        [self login];
        
        return [RACSignal empty];
    }];
}

- (void)login {
    if([NSString isBlank:self.phoneNumber]){
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
    }else if(self.phoneNumber.length != 11){
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }else if([NSString isBlank:self.password]){
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
    }else if(self.password.length < 6 || self.password.length > 18){
        [SVProgressHUD showInfoWithStatus:@"请输入6-18位密码"];
    }else{
        [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeBlack];
        GNLoginNPS *nps = [GNLoginNPS NPSWithPhoneNumber:self.phoneNumber password:self.password];
        __weakify;
        [GNNetworkService POSTWithService:nps success:^(id response, id model) {
            __strongify;
            [self settingsWhileLogined:response];
            self.loginResponse.success(response, model);
        } error:^(id response, NSInteger code) {
            __strongify;
            self.loginResponse.error(response,code);
        } failure:^(id req, NSError *error) {
            __strongify;
            self.loginResponse.failure(req,error);
        }];
    }
}




-(void)silenceLogin {
    self.phoneNumber = [GNApp userMobile];
    self.password = [GNApp userPassword];
    if(!self.phoneNumber || !self.password){
        [self showLoginDialog];
        return;
    }
    
    GNLoginNPS *nps = [GNLoginNPS NPSWithPhoneNumber:self.phoneNumber password:self.password];
    __weakify;
    [GNNetworkService POSTWithService:nps success:^(id response, id model) {
        __strongify;
        [self settingsWhileLogined:response];
    } error:^(id response, NSInteger code) {
        __strongify;
        //重新登录
        [self showLoginDialog];
    } failure:^(id req, NSError *error) {
        
    }];
}


-(void)settingsWhileLogined:(id) response{
    [GNApp setUserId:[response[@"user_id"] integerValue]];
    [GNApp setTeamOwner:[response[@"is_team_owner"] boolValue]];
    [GNApp setUserMobile:self.phoneNumber];
    [GNApp setUserPassword:self.password];
    [GNPushSubscibeService unsubscribeNotLogin];
    [GNPushSubscibeService sync];
    [GNPushSubscibeService setAlias:[response objectForKey:@"push_alias"]];
    [GNApp userDidLogin];
}


-(void)showLoginDialog {
    if(!self.lertView){
        self.lertView = [[UIAlertView alloc]initWithTitle:nil message:@"需要重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }
    [self.lertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([kApp.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        [kApp showLoginUI];
    }
}


@end
