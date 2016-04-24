//
//  GNPerfectInfoVC.m
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNPerfectInfoVC.h"
#import "UIControl+GNExtension.h"
#import "GNChooseImageService.h"
#import "GNPerfectInfoNPS.h"
#import "GNRegisterVC.h"
#import "GNRegisterNPS.h"
#import "NSString+GNExtension.h"
#import "GNUpdatePerfectInfoNPS.h"
#import "GNNetworkService.h"
#import "GNLoginVC.h"

@interface GNPerfectInfoVC ()<UIActionSheetDelegate,UITextFieldDelegate>
{
    UIActionSheet *_actionSheet;
    
}
@property (weak, nonatomic) IBOutlet UIView *view_Line1;
@property (weak, nonatomic) IBOutlet UIView *view_Line2;
@property (weak, nonatomic) IBOutlet UIView *view_Line3;
@property (weak, nonatomic) IBOutlet UIView *view_Line4;
@property (weak, nonatomic) IBOutlet UIView *view_Line5;
@property (weak, nonatomic) IBOutlet UIView *view_Line6;
@property (weak, nonatomic) IBOutlet UIView *view_Line7;
@property (weak, nonatomic) IBOutlet UIView *view_Line8;

@property (nonatomic, assign) GNGender sex;
@property(nonatomic,strong)UIImage *imageNew;

@end

@implementation GNPerfectInfoVC

+ (NSString *)sbIdentifier {
    return @"perfect_info";
}

- (void)setupUI {
    [super setupUI];

//    self.image_headerPic.layer.masksToBounds = YES;
//    self.image_headerPic.layer.cornerRadius = self.image_headerPic.bounds.size.height/2;
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self.nextButton setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
    
    [self.nextButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [self.nextButton setBackgroundColor:kUIColorWithHexUint(GNUIColorDisabled) forState:UIControlStateDisabled];
    
    UITapGestureRecognizer *gestSex = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexSelectedAction:)];
    [self.lb_SexPro addGestureRecognizer:gestSex];
    
    [self.view_Line1 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line2 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line3 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line4 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line5 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line6 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line7 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line8 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    
    [self.txt_AgePro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txt_NamePro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txt_PasswordPro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txt_PhoneNubmerPro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];

    [self.txt_AgePro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [self.txt_NamePro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [self.txt_PhoneNubmerPro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [self.txt_PasswordPro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [self.lb_SexPro setTextColor:kUIColorWithHexUint(GNUIColorBlack)];
    
    
    if(![NSString isBlank:self.phone]){
        [self.nextButton setTitle:@"完善资料" forState:UIControlStateNormal];
        NSMutableString *phone = [NSMutableString stringWithString:self.phone];
        [phone insertString:@" " atIndex:3];
        [phone insertString:@" " atIndex:8];
        self.txt_PhoneNubmerPro.text = phone;
        self.txt_PhoneNubmerPro.enabled = NO;
    }
    
    if(![NSString isBlank:self.password]){
        self.txt_PasswordPro.text = self.password;
        self.txt_PasswordPro.enabled = NO;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    UIDatePicker *_datePicker= [[UIDatePicker alloc] init];
    [_datePicker setDate:[dateFormatter dateFromString:@"1990-01-01"] animated:YES];
    [_datePicker setMaximumDate:[NSDate date]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.txt_AgePro.inputView = _datePicker;
    __weakify;
    [[self.txt_AgePro rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(id x) {
        __strongify;
        self.txt_AgePro.text = [dateFormatter stringFromDate:_datePicker.date];
    }];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPictureHeader)];
    [self.image_headerPic addGestureRecognizer:tapGest];
    self.image_headerPic.userInteractionEnabled = YES;
}

-(void)addPictureHeader{
    [self chooseImage];
}

-(void)datePickerValueChanged:(UIDatePicker *)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:sender.date];
    self.txt_AgePro.text = dateStr;
}

- (void)binding {
     __weakify;
    [RACObserve(self.lb_SexPro, text) subscribeNext:^(id x) {
        __strongify;
        if ([x isEqual:@"男"]) {
            self.sex = GNGenderMale;
        }
        else if ([x isEqual:@"女"]){
            self.sex = GNGenderFemale;
        }
    }];
    
    self.txt_PhoneNubmerPro.delegate = self;
    self.btnGetImagePro.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        [self chooseImage];
        return [RACSignal empty];
    }];
    self.nextButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input)
                                   {
                                       __strongify;
                                       if ([NSString isBlank:self.txt_PhoneNubmerPro.text] || self.txt_PhoneNubmerPro.text.length != 13) {
                                           [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
                                       }else if (self.txt_PasswordPro.text.length < 6 || self.txt_PasswordPro.text.length > 32) {
                                           [SVProgressHUD showInfoWithStatus:@"密码长度应为6-32位"];
                                       }else if ([NSString isBlank:self.txt_NamePro.text]) {
                                           [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
                                       }else if (self.sex <= 0) {
                                           [SVProgressHUD showInfoWithStatus:@"请选择性别"];
                                       }else if ([NSString isBlank:self.txt_AgePro.text]) {
                                           [SVProgressHUD showInfoWithStatus:@"请输入年龄"];
                                       }else if (!self.imageNew) {
                                           [SVProgressHUD showInfoWithStatus:@"请长传头像"];
                                       }else{
                                           if([NSString isBlank:self.phone]){
                                               [self pushToRegisterVC];
                                           }else{
                                               [self savePerfectInfo];
                                           }
                                       }
                                       return [RACSignal empty];
                                   }];
    
    
    
    
}

- (void)chooseImage {
    __weakify;
    [GNChooseImageService chooseImageWithController:self finishedBlock:^(UIImage *image) {
        __strongify;
        self.image_headerPic.image = image;
        self.imageNew = image;
    }];
}

-(void)pushToRegisterVC{
    GNPerfectInfoNPS *nps = [GNPerfectInfoNPS NPSWithPhoneNumber:[self.txt_PhoneNubmerPro.text stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                        password:self.txt_PasswordPro.text
                                                            name:self.txt_NamePro.text
                                                             sex:self.sex
                                                             age:self.txt_AgePro.text
                                                    headPortrait:UIImagePNGRepresentation(self.image_headerPic.image)
                                                          tagIds:self.tagIds];
    
    GNRegisterVC *registerUI = [GNRegisterVC loadFromStoryboard];
    registerUI.perfectInfoNPS = nps;
    [self.navigationController pushViewController:registerUI animated:YES];
}


-(void)savePerfectInfo{
    [SVProgressHUD showWithStatus:@"提交中，请稍后" maskType:SVProgressHUDMaskTypeBlack];
    GNUpdatePerfectInfoNPS *nps = [GNUpdatePerfectInfoNPS NPSWithPassword:self.txt_PasswordPro.text name:self.txt_NamePro.text sex:self.sex age:self.txt_AgePro.text tagids:self.tagIds headPortrait:UIImagePNGRepresentation(self.image_headerPic.image)];
    __weakify;
    [GNNetworkService POSTWithService:nps success:^(id response, id model) {
        __strongify;
        [SVProgressHUD dismiss];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isMemberOfClass:NSClassFromString(@"GNLoginVC")]) {
                [self.navigationController popToViewController:obj animated:YES];
                [(GNLoginVC*)obj startLoginWithPhone:self.phone password:self.txt_PasswordPro.text];
                *stop = YES;
            }
        }];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"保存个人资料失败!"];
    }];
}

-(void)sexSelectedAction:(id)sender{
    _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女",nil];
    [_actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        self.lb_SexPro.text = @"男";
    }
    else if(buttonIndex==1)
    {
        self.lb_SexPro.text= @"女";
    }
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
