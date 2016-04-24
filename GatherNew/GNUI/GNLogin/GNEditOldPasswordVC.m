//
//  GNEditOldPasswordVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNEditOldPasswordVC.h"
#import "UIControl+GNExtension.h"
#import "GNEditOldPasswordVM.h"

@interface GNEditOldPasswordVC ()

@property (nonatomic, strong) GNEditOldPasswordVM *viewModel;

@end

@implementation GNEditOldPasswordVC

+(NSString *)sbIdentifier{
    return @"editOldPassword";
}

-(void)setupUI{
    [super setupUI];
    
    [self.lbFirstPWD setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lbOldPWD setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lbSecondPWD setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.txtOldPWD setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lbFirstPWD setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.lbSecondPWD setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    
    [self.txtOldPWD setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txtFirstPWD setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txtSecondPWD setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    

    [self.btnOk setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [self.btnOk setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [self.btnOk setBackgroundColor:kUIColorWithHexUint(GNUIColorDisabled) forState:UIControlStateDisabled];
    
    
    [self.view_Line1 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line2 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line3 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line4 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
}

- (void)binding {
    
    self.viewModel = [[GNEditOldPasswordVM alloc]init];
    
    RAC(self.viewModel,oldPassword) = self.txtOldPWD.rac_textSignal;
    RAC(self.viewModel,firstPassword) = self.txtFirstPWD.rac_textSignal;
    
    self.btnOk.rac_command = self.viewModel.nextCommand;

    
    [self.viewModel.nextResponce start:NO success:^(id response, id model){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"修改失败"];
    }];

}

@end
